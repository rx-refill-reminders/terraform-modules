variable "api_id" {
  description = "HTTP API Gateway ID (from the api-gateway module)"
  type        = string
}

variable "gateway_execution_arn" {
  description = "HTTP API execution ARN (from the api-gateway module), used for Lambda invoke permissions"
  type        = string
}

variable "endpoints" {
  description = "Routes to expose on the API, each wired to a Lambda via AWS_PROXY"
  type = list(object({
    route  = string
    method = string

    handler_function_name = string

    authorization = optional(object({
      authorizer_id   = string
      authorizer_type = string
      required_scopes = optional(list(string))
    }))
  }))
}
