resource "aws_cognito_user_pool_domain" "domain" {
  user_pool_id = aws_cognito_user_pool.pool.id

  domain = var.domain.mode == "user-hosted" ? var.domain.user_hosted.domain : var.domain.cognito_hosted.prefix

  certificate_arn = var.domain.mode == "user-hotsed" ? var.domain.user_hosted.certificate_arn : null
}

resource "aws_route53_record" "dns_alias" {
  count = var.domain.mode == "user-hosted" ? 1 : 0

  name    = var.domain.user_hosted.domain
  zone_id = var.domain.user_hosted.hosted_zone_id

  type = "A"

  alias {
    name                   = aws_cognito_user_pool_domain.domain.cloudfront_distribution
    zone_id                = aws_cognito_user_pool_domain.domain.cloudfront_distribution_zone_id
    evaluate_target_health = false
  }
}

locals {
  cognito_hostname = var.domain.mode == "user-hosted" ? var.domain.user_hosted.domain : "${var.domain.cognito_hosted.prefix}.auth.${aws_cognito_user_pool_domain.domain.region}.amazoncognito.com"
  cognito_url      = "https://${local.cognito_hostname}"
}
