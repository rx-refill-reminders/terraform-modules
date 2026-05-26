# api-gateway-routes

Wires HTTP API Gateway (v2) routes to Lambda functions. Use together with the `api-gateway` module, which creates the API and stage.

## Example

```hcl
module "api" {
  source = "../api-gateway"

  name = "my-api"
}

module "api_routes" {
  source = "../api-gateway-routes"

  api_id                = module.api.gateway_id
  gateway_execution_arn = module.api.gateway_execution_arn

  endpoints = [
    {
      route              = "/health"
      method             = "GET"
      handler_invoke_arn = module.health_lambda.invoke_arn
    },
    {
      route              = "/{proxy+}"
      method             = "ANY"
      handler_invoke_arn = module.app_lambda.invoke_arn
    },
  ]
}
```

Each `endpoint` object:

| Field | Description |
|-------|-------------|
| `route` | Path on the API (e.g. `/users`, `/{proxy+}`) |
| `method` | HTTP method (`GET`, `POST`, `ANY`, …) |
| `handler_invoke_arn` | Lambda `invoke_arn` from the lambda-function module |

Route keys are built as `"${METHOD} ${route}"` (method uppercased). Duplicate method + route pairs are not allowed.

Lambda invoke permissions are created once per distinct `handler_invoke_arn`.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_integration.integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration) | resource |
| [aws_apigatewayv2_route.route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route) | resource |
| [aws_lambda_permission.handler_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_apigatewayv2_api.gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/apigatewayv2_api) | data source |
| [aws_lambda_function.handler_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lambda_function) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_id"></a> [api\_id](#input\_api\_id) | HTTP API Gateway ID (from the api-gateway module) | `string` | n/a | yes |
| <a name="input_endpoints"></a> [endpoints](#input\_endpoints) | Routes to expose on the API, each wired to a Lambda via AWS\_PROXY | <pre>list(object({<br/>    route  = string<br/>    method = string<br/><br/>    handler_function_name = string<br/><br/>    authorization = optional(object({<br/>      authorizer_id   = string<br/>      authorizer_type = string<br/>      required_scopes = optional(list(string))<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_gateway_execution_arn"></a> [gateway\_execution\_arn](#input\_gateway\_execution\_arn) | HTTP API execution ARN (from the api-gateway module), used for Lambda invoke permissions | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->