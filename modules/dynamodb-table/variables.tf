variable "table_name" {
  type = string
}

variable "attributes" {
  type = list(object({
    name = string
    type = string
  }))

  description = "See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table#attribute"

  validation {
    condition     = length(var.attributes) > 0
    error_message = "Must specify at least one attribute"
  }
}

variable "hash_key" {
  type = string
}

variable "range_key" {
  type    = string
  default = null
}

variable "ttl_attribute" {
  type        = string
  default     = null
  description = "Attribute to use for TTL. Must contain a Unix epoch timestamp, in seconds"
}

variable "global_secondary_index_map" {
  description = "Additional global secondary indexes in the form of a list of mapped values"
  type = list(object({
    name               = string
    hash_key           = string
    range_key          = optional(string)
    non_key_attributes = optional(list(string))
    projection_type    = string
  }))
  default = []
}

variable "create_timeout" {
  description = "The terraform timeout for creating dynamodb global table"
  type        = string
  default     = "120m"
}

variable "update_timeout" {
  description = "The terraform timeout for updating dynamodb global table"
  type        = string
  default     = "120m"
}

variable "editors" {
  type    = list(string)
  default = []
}
