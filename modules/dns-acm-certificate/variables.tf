variable "domain_name" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "validation" {
  type = object({
    enabled           = true
    validation_domain = optional(string)
  })

  default = {
    enabled = false
  }
}
