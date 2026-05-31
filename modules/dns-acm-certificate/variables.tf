variable "domain_name" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "validation" {
  type = object({
    enabled           = bool
    validation_domain = optional(string)
  })

  default = {
    enabled = false
  }
}
