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
