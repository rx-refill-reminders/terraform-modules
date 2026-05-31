variable "name" {
  description = "API Gateway name (also used for the stage and CloudWatch log group path)"
  type        = string
}

variable "domain" {
  description = "Custom domain for the API (ACM cert, API Gateway domain, Route53 alias). Omit for execute-api URL only."
  type = object({
    zone_id  = string
    hostname = string

    certificate = optional(object({
      mode            = string
      lookup_domain   = optional(string)
      lookup_statuses = optional(list(string))
    }))
  })
  default = null

  validation {
    condition = (
      var.domain == null
      || var.domain.certificate == null
      || contains(["create", "lookup"], var.domain.certificate.mode)
    )
    error_message = "When domain.certificate is set, mode must be \"create\" or \"lookup\"."
  }

  validation {
    condition = (
      var.domain == null
      || var.domain.certificate == null
      || var.domain.certificate.mode != "create"
      || (
        var.domain.certificate.lookup_domain == null
        && var.domain.certificate.lookup_statuses == null
      )
    )
    error_message = "When domain.certificate.mode is \"create\", lookup_domain and lookup_statuses must not be set."
  }

  validation {
    condition = (
      var.domain == null
      || var.domain.certificate == null
      || var.domain.certificate.mode != "lookup"
      || var.domain.certificate.lookup_domain != null
    )
    error_message = "When domain.certificate.mode is \"lookup\", lookup_domain is required."
  }
}
