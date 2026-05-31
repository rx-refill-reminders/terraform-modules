# static-website

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_origin_access_control.oac](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_route53_record.custom_domain_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_ownership_controls.ownership](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.encryption](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name_prefix"></a> [bucket\_name\_prefix](#input\_bucket\_name\_prefix) | Name prefix for the S3 bucket | `string` | n/a | yes |
| <a name="input_custom_domain"></a> [custom\_domain](#input\_custom\_domain) | DNS alias for the website | <pre>object({<br/>    hosted_zone_id  = string<br/>    domain_name     = string<br/>    certificate_arn = string<br/>  })</pre> | `null` | no |
| <a name="input_custom_error_responses"></a> [custom\_error\_responses](#input\_custom\_error\_responses) | List of custom error responses for the CloudFront distribution | <pre>list(object({<br/>    error_code            = number<br/>    response_code         = number<br/>    response_page_path    = string<br/>    error_caching_min_ttl = optional(number, 300)<br/>  }))</pre> | `[]` | no |
| <a name="input_default_ttl"></a> [default\_ttl](#input\_default\_ttl) | Default TTL for cached content (in seconds) | `number` | `86400` | no |
| <a name="input_enable_compression"></a> [enable\_compression](#input\_enable\_compression) | Enable compression for the CloudFront distribution | `bool` | `true` | no |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Enable IPv6 for the CloudFront distribution | `bool` | `true` | no |
| <a name="input_enable_versioning"></a> [enable\_versioning](#input\_enable\_versioning) | Enable versioning on the S3 bucket | `bool` | `false` | no |
| <a name="input_error_document"></a> [error\_document](#input\_error\_document) | The error document for the website (e.g., error.html) | `string` | `"error.html"` | no |
| <a name="input_geo_restriction_locations"></a> [geo\_restriction\_locations](#input\_geo\_restriction\_locations) | List of country codes for geo restriction (required if geo\_restriction\_type is whitelist or blacklist) | `list(string)` | `[]` | no |
| <a name="input_geo_restriction_type"></a> [geo\_restriction\_type](#input\_geo\_restriction\_type) | Type of geo restriction. Options: none, whitelist, blacklist | `string` | `"none"` | no |
| <a name="input_index_document"></a> [index\_document](#input\_index\_document) | The index document for the website (e.g., index.html) | `string` | `"index.html"` | no |
| <a name="input_max_ttl"></a> [max\_ttl](#input\_max\_ttl) | Maximum TTL for cached content (in seconds) | `number` | `31536000` | no |
| <a name="input_min_ttl"></a> [min\_ttl](#input\_min\_ttl) | Minimum TTL for cached content (in seconds) | `number` | `0` | no |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | Price class for CloudFront distribution. Options: PriceClass\_All, PriceClass\_200, PriceClass\_100 | `string` | `"PriceClass_All"` | no |
| <a name="input_viewer_protocol_policy"></a> [viewer\_protocol\_policy](#input\_viewer\_protocol\_policy) | The protocol that viewers can use to access the files. Options: allow-all, https-only, redirect-to-https | `string` | `"redirect-to-https"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | The ARN of the S3 bucket |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The ID of the S3 bucket |
| <a name="output_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#output\_bucket\_regional\_domain\_name) | The regional domain name of the S3 bucket (used by CloudFront) |
| <a name="output_cloudfront_distribution_arn"></a> [cloudfront\_distribution\_arn](#output\_cloudfront\_distribution\_arn) | The ARN of the CloudFront distribution |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | The ID of the CloudFront distribution |
| <a name="output_cloudfront_domain_name"></a> [cloudfront\_domain\_name](#output\_cloudfront\_domain\_name) | The domain name of the CloudFront distribution (e.g., d1234abcd.cloudfront.net) |
| <a name="output_cloudfront_hosted_zone_id"></a> [cloudfront\_hosted\_zone\_id](#output\_cloudfront\_hosted\_zone\_id) | The CloudFront Route 53 zone ID that can be used to route an Alias resource record set to |
| <a name="output_origin_access_control_id"></a> [origin\_access\_control\_id](#output\_origin\_access\_control\_id) | The ID of the Origin Access Control |
| <a name="output_website_url"></a> [website\_url](#output\_website\_url) | The URL of the website (CloudFront domain name) |
<!-- END_TF_DOCS -->
