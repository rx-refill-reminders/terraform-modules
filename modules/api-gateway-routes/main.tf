locals {
  handler_function_names     = toset(var.endpoints[*].handler_function_name)
  handler_function_names_map = tomap({ for name in local.handler_function_names : name => name })

  endpoints_by_route_key = {
    for endpoint in var.endpoints :
    "${upper(endpoint.method)} ${endpoint.route}" => endpoint
  }
}

# Lookup the API gateway
data "aws_apigatewayv2_api" "gateway" {
  api_id = var.api_id
}

# Lookup each handler function
data "aws_lambda_function" "handler_function" {
  for_each      = local.handler_function_names_map
  function_name = each.value
}

resource "aws_lambda_permission" "handler_permission" {
  for_each = local.handler_function_names_map

  action        = "lambda:InvokeFunction"
  function_name = each.value
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${data.aws_apigatewayv2_api.gateway.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "integration" {
  for_each = local.endpoints_by_route_key

  api_id           = var.api_id
  integration_type = "AWS_PROXY"
  integration_uri  = data.aws_lambda_function.handler_function[each.value.handler_function_name].invoke_arn

  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "route" {
  for_each = local.endpoints_by_route_key

  api_id = var.api_id

  route_key = each.key
  target    = "integrations/${aws_apigatewayv2_integration.lambda[each.key].id}"

  authorizer_id        = each.value.authorization != null ? each.value.authorization.authorizer_id : null
  authorization_type   = each.value.authorization != null ? each.value.authorization.authorizer_type : null
  authorization_scopes = each.value.authorization != null ? each.value.authorization.required_scopes : null
}
