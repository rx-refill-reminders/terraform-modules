# iOS App Client - For user authentication
resource "aws_cognito_user_pool_client" "app" {
  for_each = var.clients.apps

  name         = each.key
  user_pool_id = aws_cognito_user_pool.pool.id

  # OAuth settings
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes = concat(
    ["email", "openid", "profile"],
    [for scope in var.resource_server_scopes : "${var.resource_server_identifier}/${scope.name}"]
  )

  callback_urls = each.value.callback_urls
  logout_urls   = each.value.logout_urls

  # Supported identity providers
  supported_identity_providers = concat(
    ["COGNITO"],
    var.enable_apple_signin ? ["SignInWithApple"] : [],
    var.enable_google_signin ? ["Google"] : []
  )

  # Token validity periods
  access_token_validity  = 60 # 1 hour
  id_token_validity      = 60 # 1 hour
  refresh_token_validity = 30 # 30 days

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }

  # Enable PKCE for security
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]

  # Prevent client secret (not needed for PKCE flow)
  generate_secret = false

  # Read/write attributes
  read_attributes = [
    "email",
    "email_verified",
    "given_name",
    "family_name"
  ]

  write_attributes = [
    "email",
    "given_name",
    "family_name"
  ]

  depends_on = [aws_cognito_resource_server.api]
}

# Service Client - For machine-to-machine authentication
resource "aws_cognito_user_pool_client" "m2m" {
  for_each = var.clients.m2m

  name         = each.key
  user_pool_id = aws_cognito_user_pool.pool.id

  # OAuth settings for client credentials flow
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["client_credentials"]
  allowed_oauth_scopes = [
    for scope in var.resource_server_scopes : "${var.resource_server_identifier}/${scope.name}"
  ]

  # Token validity
  access_token_validity = 60 # 1 hour

  token_validity_units {
    access_token = "minutes"
  }

  # M2M clients need a secret
  generate_secret = true

  depends_on = [aws_cognito_resource_server.api]
}

# Store service client secret in AWS Secrets Manager
resource "aws_secretsmanager_secret" "m2m_client_secret" {
  for_each = var.clients.m2m

  name        = "cognito/${var.pool_name}/m2m-secret/${each.key}"
  description = "M2M client secret for ${var.pool_name}"
}

resource "aws_secretsmanager_secret_version" "m2m_client_secret" {
  for_each = var.clients.m2m

  secret_id = aws_secretsmanager_secret.m2m_client_secret[each.key].id
  secret_string = jsonencode({
    client_id      = aws_cognito_user_pool_client.m2m[each.key].id
    client_secret  = aws_cognito_user_pool_client.m2m[each.key].client_secret
    user_pool_id   = aws_cognito_user_pool.pool.id
    cognito_domain = aws_cognito_user_pool_domain.domain.domain
    token_endpoint = "${local.cognito_url}/oauth2/token"
  })
}
