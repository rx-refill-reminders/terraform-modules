# dynamodb-table

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
| [aws_dynamodb_resource_policy.access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_resource_policy) | resource |
| [aws_dynamodb_table.table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table#attribute | <pre>list(object({<br/>    name = string<br/>    type = string<br/>  }))</pre> | n/a | yes |
| <a name="input_create_timeout"></a> [create\_timeout](#input\_create\_timeout) | The terraform timeout for creating dynamodb global table | `string` | `"120m"` | no |
| <a name="input_editors"></a> [editors](#input\_editors) | n/a | `list(string)` | `[]` | no |
| <a name="input_global_secondary_index_map"></a> [global\_secondary\_index\_map](#input\_global\_secondary\_index\_map) | Additional global secondary indexes in the form of a list of mapped values | <pre>list(object({<br/>    name               = string<br/>    hash_key           = string<br/>    range_key          = optional(string)<br/>    non_key_attributes = optional(list(string))<br/>    projection_type    = string<br/>  }))</pre> | `[]` | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | n/a | `string` | n/a | yes |
| <a name="input_range_key"></a> [range\_key](#input\_range\_key) | n/a | `string` | `null` | no |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | n/a | `string` | n/a | yes |
| <a name="input_ttl_attribute"></a> [ttl\_attribute](#input\_ttl\_attribute) | Attribute to use for TTL. Must contain a Unix epoch timestamp, in seconds | `string` | `null` | no |
| <a name="input_update_timeout"></a> [update\_timeout](#input\_update\_timeout) | The terraform timeout for updating dynamodb global table | `string` | `"120m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_table_arn"></a> [table\_arn](#output\_table\_arn) | n/a |
| <a name="output_table_name"></a> [table\_name](#output\_table\_name) | n/a |
<!-- END_TF_DOCS -->
