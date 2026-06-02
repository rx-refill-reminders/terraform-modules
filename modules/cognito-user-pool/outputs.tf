output "user_pool_id" {
  description = "The ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.pool.id
}

output "user_pool_arn" {
  description = "The ARN of the Cognito User Pool"
  value       = aws_cognito_user_pool.pool.arn
}

output "user_pool_endpoint" {
  description = "The endpoint of the Cognito User Pool"
  value       = aws_cognito_user_pool.pool.endpoint
}

output "hosted_ui_url" {
  description = "The base URL for Cognito Hosted UI"
  value       = local.cognito_url
}

output "resource_server_identifier" {
  description = "The identifier of the resource server"
  value       = aws_cognito_resource_server.api.identifier
}

output "resource_server_scopes" {
  description = "List of full scope identifiers (resource_server_id/scope_name)"
  value = [
    for scope in var.resource_server_scopes : "${var.resource_server_identifier}/${scope.name}"
  ]
}

output "client_ids" {
  value = {
    m2m = { for key, client in aws_cognito_user_pool_client.m2m : key => client.id },
    app = { for key, client in aws_cognito_user_pool_client.app : key => client.id },
  }
}

output "m2m_client_secrets" {
  value = {
    for key, secret in aws_secretsmanager_secret.m2m_client_secret : key => {
      name = secret.name
      arn = secret.arn
    }
  }
}
