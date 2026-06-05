# cognito-user-pool

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
| [aws_cognito_identity_provider.apple](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_provider) | resource |
| [aws_cognito_identity_provider.google](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_provider) | resource |
| [aws_cognito_resource_server.api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_resource_server) | resource |
| [aws_cognito_user_pool.pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_cognito_user_pool_client.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
| [aws_cognito_user_pool_client.m2m](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
| [aws_cognito_user_pool_domain.domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_domain) | resource |
| [aws_lambda_permission.allow_invoke](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_route53_record.dns_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_secretsmanager_secret.m2m_client_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.m2m_client_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apple_signin_config"></a> [apple\_signin\_config](#input\_apple\_signin\_config) | Configuration for Apple Sign In | <pre>object({<br/>    client_id   = string<br/>    team_id     = string<br/>    key_id      = string<br/>    private_key = string<br/>  })</pre> | `null` | no |
| <a name="input_clients"></a> [clients](#input\_clients) | OAuth clients | <pre>object({<br/>    m2m = map(object({}))<br/><br/>    apps = map(object({<br/>      callback_urls = list(string)<br/>      logout_urls   = list(string)<br/>    }))<br/>  })</pre> | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | Custom domain for Cognito Hosted UI | <pre>object({<br/>    mode = string<br/>    cognito_hosted = optional(object({<br/>      prefix = string<br/><br/>      dummy_alias = optional(object({<br/>        hosted_zone_id = string<br/>        domain         = string<br/>      }))<br/>    }))<br/>    user_hosted = optional(object({<br/>      hosted_zone_id  = string<br/>      domain          = string<br/>      certificate_arn = string<br/>    }))<br/>  })</pre> | n/a | yes |
| <a name="input_enable_apple_signin"></a> [enable\_apple\_signin](#input\_enable\_apple\_signin) | Enable Sign in with Apple | `bool` | `false` | no |
| <a name="input_enable_google_signin"></a> [enable\_google\_signin](#input\_enable\_google\_signin) | Enable Sign in with Google | `bool` | `false` | no |
| <a name="input_google_signin_config"></a> [google\_signin\_config](#input\_google\_signin\_config) | Configuration for Google Sign In | <pre>object({<br/>    client_id     = string<br/>    client_secret = string<br/>  })</pre> | `null` | no |
| <a name="input_lambda_trigger_arns"></a> [lambda\_trigger\_arns](#input\_lambda\_trigger\_arns) | ARNs of Lambdas to invoke for Cognito triggers. When set, a lambda\_config block is created from it. | <pre>object({<br/>    post_confirmation   = optional(string)<br/>    post_authentication = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_mfa_configuration"></a> [mfa\_configuration](#input\_mfa\_configuration) | MFA configuration: OFF, ON, or OPTIONAL | `string` | `"OFF"` | no |
| <a name="input_pool_name"></a> [pool\_name](#input\_pool\_name) | Base name for the Cognito User Pool | `string` | n/a | yes |
| <a name="input_resource_server_identifier"></a> [resource\_server\_identifier](#input\_resource\_server\_identifier) | Identifier for the API resource server (typically your API URL) | `string` | n/a | yes |
| <a name="input_resource_server_name"></a> [resource\_server\_name](#input\_resource\_server\_name) | Name for the resource server | `string` | n/a | yes |
| <a name="input_resource_server_scopes"></a> [resource\_server\_scopes](#input\_resource\_server\_scopes) | List of OAuth scopes for the API | <pre>list(object({<br/>    name        = string<br/>    description = string<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_ids"></a> [client\_ids](#output\_client\_ids) | n/a |
| <a name="output_hosted_ui_url"></a> [hosted\_ui\_url](#output\_hosted\_ui\_url) | The base URL for Cognito Hosted UI |
| <a name="output_m2m_client_secrets"></a> [m2m\_client\_secrets](#output\_m2m\_client\_secrets) | n/a |
| <a name="output_resource_server_identifier"></a> [resource\_server\_identifier](#output\_resource\_server\_identifier) | The identifier of the resource server |
| <a name="output_resource_server_scopes"></a> [resource\_server\_scopes](#output\_resource\_server\_scopes) | List of full scope identifiers (resource\_server\_id/scope\_name) |
| <a name="output_user_pool_arn"></a> [user\_pool\_arn](#output\_user\_pool\_arn) | The ARN of the Cognito User Pool |
| <a name="output_user_pool_endpoint"></a> [user\_pool\_endpoint](#output\_user\_pool\_endpoint) | The endpoint of the Cognito User Pool |
| <a name="output_user_pool_id"></a> [user\_pool\_id](#output\_user\_pool\_id) | The ID of the Cognito User Pool |
<!-- END_TF_DOCS -->