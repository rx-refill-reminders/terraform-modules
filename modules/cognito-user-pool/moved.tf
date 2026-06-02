moved {
  from = aws_cognito_user_pool_client.web_app[0]
  to   = aws_cognito_user_pool_client.app["web"]
}

moved {
  from = aws_cognito_user_pool_client.ios_app
  to   = aws_cognito_user_pool_client.app["ios"]
}

moved {
  from = aws_cognito_user_pool_client.service[0]
  to   = aws_cognito_user_pool_client.m2m["automations"]
}

moved {
  from = aws_secretsmanager_secret.service_client_secret[0]
  to   = aws_secretsmanager_secret.m2m_client_secret["web"]
}

moved {
  from = aws_secretsmanager_secret_version.service_client_secret[0]
  to   = aws_secretsmanager_secret_version.m2m_client_secret["web"]
}

moved {
  from = aws_route53_record.custom_domain_alias[0]
  to   = aws_route53_record.dns_alias[0]
}
