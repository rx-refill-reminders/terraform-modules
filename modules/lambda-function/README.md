# lambda-function

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_lambda_function.function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_s3_object.code_object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_code_bucket_id"></a> [code\_bucket\_id](#input\_code\_bucket\_id) | The ID of the S3 bucket in which this Lambda's code should be saved | `string` | n/a | yes |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | Environment variables to assign to the Lambda function | `map(string)` | `{}` | no |
| <a name="input_executable_zip"></a> [executable\_zip](#input\_executable\_zip) | The ZIP file containing the executable | `string` | n/a | yes |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Lambda function name | `string` | n/a | yes |
| <a name="input_handler"></a> [handler](#input\_handler) | The handler entrypoint for the Lambda function | `string` | n/a | yes |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | n/a | `string` | n/a | yes |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | n/a | `string` | `"provided.al2023"` | no |
| <a name="input_timeout_seconds"></a> [timeout\_seconds](#input\_timeout\_seconds) | The timeout, in seconds, for the Lambda function | `number` | `3` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_arn"></a> [function\_arn](#output\_function\_arn) | n/a |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | n/a |
| <a name="output_invoke_arn"></a> [invoke\_arn](#output\_invoke\_arn) | n/a |
<!-- END_TF_DOCS -->
