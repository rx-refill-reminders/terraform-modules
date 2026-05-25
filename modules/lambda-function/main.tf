# For Go functions, the zip file is pre-built by the build script
locals {
  zip_file_path = "${var.dist_path}/${var.function_name}.zip"
}

resource "aws_s3_object" "code_object" {
  bucket = var.code_bucket_id

  key    = "${var.function_name}.zip"
  source = local.zip_file_path

  source_hash = filebase64sha256(local.zip_file_path)
}

resource "aws_lambda_function" "function" {
  function_name = var.function_name

  s3_bucket         = var.code_bucket_id
  s3_key            = aws_s3_object.code_object.key
  s3_object_version = aws_s3_object.code_object.version_id
  source_code_hash  = aws_s3_object.code_object.source_hash

  handler = var.handler

  runtime = var.runtime
  role    = var.role_arn
  timeout = var.timeout_seconds

  environment {
    variables = var.env_vars
  }
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name = "/aws/lambda/${aws_lambda_function.function.function_name}"

  retention_in_days = 30
}
