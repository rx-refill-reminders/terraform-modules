# CloudFront Distribution
resource "aws_cloudfront_distribution" "distribution" {
  comment = "CloudFront distribution for ${var.bucket_name}"

  enabled             = true
  is_ipv6_enabled     = var.enable_ipv6
  default_root_object = var.index_document
  price_class         = var.price_class

  # Use the S3 REST API endpoint as origin (not website endpoint)
  # This allows us to use OAC and keep the bucket private
  origin {
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id                = "S3-${var.bucket_name}"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  # Default cache behavior
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.bucket_name}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = var.viewer_protocol_policy
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
    compress               = var.enable_compression
  }

  # Custom domain and SSL certificate
  aliases = var.dns_aliases[*].route53_hostname

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = var.acm_certificate_arn != null ? "sni-only" : null
    minimum_protocol_version       = var.acm_certificate_arn != null ? var.minimum_protocol_version : null
    cloudfront_default_certificate = var.acm_certificate_arn == null
  }

  # Custom error responses
  dynamic "custom_error_response" {
    for_each = var.custom_error_responses
    content {
      error_code            = custom_error_response.value.error_code
      response_code         = custom_error_response.value.response_code
      response_page_path    = custom_error_response.value.response_page_path
      error_caching_min_ttl = try(custom_error_response.value.error_caching_min_ttl, 300)
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }

  tags = module.tags
}

# Route53 ALIAS record pointing to CloudFront distribution
resource "aws_route53_record" "dns_alias" {
  count = var.route53_zone_id != null && var.route53_record_name != null ? 1 : 0

  zone_id = var.route53_zone_id
  name    = var.route53_record_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}

module "api_cert" {
  count = var.domain != null ? 1 : 0

  source = "../dns-acm-certificate"

  domain_name = var.domain.hostname
  zone_id     = var.domain.zone_id
  validate    = true

  providers = {
    aws.default   = aws
    aws.us_east_1 = aws.us_east_1
  }
}
