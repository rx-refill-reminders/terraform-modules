module "api_cert" {
  count = var.domain != null && var.domain.certificate_arn != null ? 1 : 0

  source = "git::github.com/rx-refill-reminders/terraform-modules//modules/dns-acm-certificate?ref=dns-acm-certificate%2Fv1&depth=0"

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
  count = var.domain != null ? 1 : 0

  domain_name = var.domain.hostname

  domain_name_configuration {
    certificate_arn = var.domain.certificate_arn != null ? var.domain.certificate_arn : module.api_cert[0].certificate_arn
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
