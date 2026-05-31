locals {
  create_domain = var.domain != null

  create_certificate = var.domain != null && var.domain.certificate != null && var.domain.certificate.mode == "create"
  lookup_certificate = var.domain != null && var.domain.certificate != null && var.domain.certificate.mode == "lookup"
}

data "aws_acm_certificate" "certificate" {
  count = local.lookup_certificate ? 1 : 0

  domain   = var.domain.certificate.lookup_domain
  statuses = var.domain.certificate.lookup_statuses

  provider = aws.us_east_1
}

moved {
  from = module.api_cert
  to   = module.domain_certificate
}

module "domain_certificate" {
  count = local.create_domain ? 1 : 0

  source = "../dns-acm-certificate"

  domain_name = var.domain.hostname
  zone_id     = var.domain.zone_id

  validation = {
    enabled = true
  }

  providers = {
    aws = aws.us_east_1
  }
}

resource "aws_apigatewayv2_domain_name" "domain" {
  count = local.create_domain ? 1 : 0

  domain_name = var.domain.hostname

  domain_name_configuration {
    certificate_arn = local.create_domain ? module.domain_certificate[0].certificate_arn : data.aws_acm_certificate.certificate[0].arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_api_mapping" "mapping" {
  count = var.domain != null ? 1 : 0

  api_id      = aws_apigatewayv2_api.api.id
  domain_name = aws_apigatewayv2_domain_name.domain[0].id
  stage       = aws_apigatewayv2_stage.stage.name
}

resource "aws_route53_record" "alias" {
  count = var.domain != null ? 1 : 0

  zone_id = var.domain.zone_id
  name    = var.domain.hostname
  type    = "A"

  alias {
    name                   = aws_apigatewayv2_domain_name.domain[0].domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.domain[0].domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}
