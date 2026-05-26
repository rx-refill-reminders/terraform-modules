data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# Shared S3 bucket for Lambda deployment packages, namespaced per account and region.
resource "aws_s3_bucket" "bucket" {
  bucket           = "${var.bucket_name_prefix}-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.region}-an"
  bucket_namespace = "account-regional"
}

# Encrypts all objects at rest with SSE-S3 (AES256).
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enables object versions so Lambda deployments can reference a specific S3 object version.
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Prefers bucket-owner object ownership, required before applying a private bucket ACL.
resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Blocks public ACLs, policies, and cross-account public access on the code bucket.
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Sets the bucket ACL to private after ownership and public-access safeguards are in place.
resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ownership_controls,
    aws_s3_bucket_public_access_block.block,
  ]

  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}
