variable "pool_name" {
  description = "Base name for the Cognito User Pool"
  type        = string
}

# Custom domain for Cognito Hosted UI
variable "domain" {
  type = object({
    mode = string
    cognito_hosted = optional(object({
      prefix = string

      dummy_alias = optional(object({
        hosted_zone_id = string
        domain         = string
      }))
    }))
    user_hosted = optional(object({
      hosted_zone_id  = string
      domain          = string
      certificate_arn = string
    }))
  })

  validation {
    condition     = contains(["cognito-hosted", "user-hosted"], var.domain.mode)
    error_message = "domain.mode must be either cognito-hosted or user-hosted."
  }

  validation {
    condition = (
      var.domain.mode != "cognito-hosted"
      || var.domain.user_hosted == null
    )
    error_message = "domain.user_hosted must not be set when domain.mode is cognito-hosted."
  }

  validation {
    condition = (
      var.domain.mode != "user-hosted"
      || var.domain.cognito_hosted == null
    )
    error_message = "domain.cognito_hosted must not be set when domain.mode is user-hosted."
  }

  validation {
    condition = (
      var.domain.mode != "cognito-hosted"
      || var.domain.cognito_hosted != null
    )
    error_message = "domain.cognito_hosted must be set when domain.mode is cognito-hosted."
  }

  validation {
    condition = (
      var.domain.mode != "user-hosted"
      || var.domain.user_hosted != null
    )
    error_message = "domain.user_hosted must be set when domain.mode is user-hosted."
  }
}

variable "resource_server_identifier" {
  description = "Identifier for the API resource server (typically your API URL)"
  type        = string
}

variable "resource_server_name" {
  description = "Name for the resource server"
  type        = string
}

variable "resource_server_scopes" {
  description = "List of OAuth scopes for the API"
  type = list(object({
    name        = string
    description = string
  }))
}

variable "clients" {
  description = "OAuth clients"

  type = object({
    m2m = map(object({}))

    apps = map(object({
      callback_urls = list(string)
      logout_urls   = list(string)
    }))
  })
}

variable "mfa_configuration" {
  description = "MFA configuration: OFF, ON, or OPTIONAL"
  type        = string
  default     = "OFF"

  validation {
    condition     = contains(["OFF", "ON", "OPTIONAL"], var.mfa_configuration)
    error_message = "MFA configuration must be OFF, ON, or OPTIONAL"
  }
}

# Social Sign-In Configuration

variable "enable_apple_signin" {
  description = "Enable Sign in with Apple"
  type        = bool
  default     = false
}

variable "apple_signin_config" {
  description = "Configuration for Apple Sign In"
  type = object({
    client_id   = string
    team_id     = string
    key_id      = string
    private_key = string
  })
  default   = null
  sensitive = true
}

variable "enable_google_signin" {
  description = "Enable Sign in with Google"
  type        = bool
  default     = false
}

variable "google_signin_config" {
  description = "Configuration for Google Sign In"
  type = object({
    client_id     = string
    client_secret = string
  })
  default   = null
  sensitive = true
}

variable "lambda_trigger_arns" {
  description = "ARNs of Lambdas to invoke for Cognito triggers. When set, a lambda_config block is created from it."
  type = object({
    post_confirmation   = optional(string)
    post_authentication = optional(string)
  })
  default = null
}
