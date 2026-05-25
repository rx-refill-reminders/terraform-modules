variable "function_name" {
  description = "Lambda function name"
  type        = string
}

variable "runtime" {
  type    = string
  default = "provided.al2023"
}

variable "timeout_seconds" {
  description = "The timeout, in seconds, for the Lambda function"
  type        = number
  default     = 3
}

variable "role_arn" {
  type = string
}

variable "handler" {
  description = "The handler entrypoint for the Lambda function"
  type        = string
}

variable "code_bucket_id" {
  description = "The ID of the S3 bucket in which this Lambda's code should be saved"
  type        = string
}

variable "dist_path" {
  description = "Directory containing {function_name}.zip deployment artifacts"
  type        = string
}

variable "env_vars" {
  type        = map(string)
  default     = {}
  description = "Environment variables to assign to the Lambda function"
}
