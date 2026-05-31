locals {
  tls_protocol_version = "TLSv1.2_2021"

  custom_domain_enabled = var.custom_domain != null
}

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
  aliases = local.custom_domain_enabled ? [var.custom_domain.domain_name] : []

  viewer_certificate {
    acm_certificate_arn            = var.custom_domain.certificate_arn
    ssl_support_method             = local.custom_domain_enabled ? "sni-only" : null
    minimum_protocol_version       = local.tls_protocol_version
    cloudfront_default_certificate = !local.custom_domain_enabled
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
resource "aws_route53_record" "custom_domain_alias" {
  count = local.custom_domain_enabled ? 1 : 0

  zone_id = var.custom_domain.hosted_zone_id
  name    = var.custom_domain.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website.domain_name
    zone_id                = aws_cloudfront_distribution.website.hosted_zone_id
    evaluate_target_health = false
  }
}
