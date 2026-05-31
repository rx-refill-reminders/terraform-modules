variable "custom_domain" {
  description = "DNS alias for the website"
  default     = null
  type = object({
    hosted_zone_id  = string
    domain_name     = string
    certificate_arn = string
  })
}

variable "bucket_name_prefix" {
  description = "Name prefix for the S3 bucket"
  type        = string
}

variable "index_document" {
  description = "The index document for the website (e.g., index.html)"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "The error document for the website (e.g., error.html)"
  type        = string
  default     = "error.html"
}

variable "enable_versioning" {
  description = "Enable versioning on the S3 bucket"
  type        = bool
  default     = false
}

variable "viewer_protocol_policy" {
  description = "The protocol that viewers can use to access the files. Options: allow-all, https-only, redirect-to-https"
  type        = string
  default     = "redirect-to-https"

  validation {
    condition     = contains(["allow-all", "https-only", "redirect-to-https"], var.viewer_protocol_policy)
    error_message = "viewer_protocol_policy must be one of: allow-all, https-only, redirect-to-https"
  }
}

variable "enable_ipv6" {
  description = "Enable IPv6 for the CloudFront distribution"
  type        = bool
  default     = true
}

variable "price_class" {
  description = "Price class for CloudFront distribution. Options: PriceClass_All, PriceClass_200, PriceClass_100"
  type        = string
  default     = "PriceClass_All"

  validation {
    condition     = contains(["PriceClass_All", "PriceClass_200", "PriceClass_100"], var.price_class)
    error_message = "price_class must be one of: PriceClass_All, PriceClass_200, PriceClass_100"
  }
}

variable "min_ttl" {
  description = "Minimum TTL for cached content (in seconds)"
  type        = number
  default     = 0
}

variable "default_ttl" {
  description = "Default TTL for cached content (in seconds)"
  type        = number
  default     = 86400
}

variable "max_ttl" {
  description = "Maximum TTL for cached content (in seconds)"
  type        = number
  default     = 31536000
}

variable "enable_compression" {
  description = "Enable compression for the CloudFront distribution"
  type        = bool
  default     = true
}

variable "geo_restriction_type" {
  description = "Type of geo restriction. Options: none, whitelist, blacklist"
  type        = string
  default     = "none"

  validation {
    condition     = contains(["none", "whitelist", "blacklist"], var.geo_restriction_type)
    error_message = "geo_restriction_type must be one of: none, whitelist, blacklist"
  }
}

variable "geo_restriction_locations" {
  description = "List of country codes for geo restriction (required if geo_restriction_type is whitelist or blacklist)"
  type        = list(string)
  default     = []
}

variable "custom_error_responses" {
  description = "List of custom error responses for the CloudFront distribution"
  type = list(object({
    error_code            = number
    response_code         = number
    response_page_path    = string
    error_caching_min_ttl = optional(number, 300)
  }))
  default = []
}
