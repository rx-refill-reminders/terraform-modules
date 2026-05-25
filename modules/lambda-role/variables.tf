variable "role_name_prefix" {
  description = "Prefix for the IAM role name (account ID is appended)"

  type = string
}

variable "user_files_bucket_arn" {
  description = "ARN of the user-files S3 bucket (enables PutObject, GetObject, DeleteObject)"

  type    = string
  default = null
}
