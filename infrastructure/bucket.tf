resource "aws_s3_bucket" "main" {
  provider      = aws.security_log
  bucket        = local.s3_bucket_name
  force_destroy = true

  tags = {
    Name = "cloudtrail"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  provider = aws.security_log
  bucket   = aws_s3_bucket.main.id

  rule {
    bucket_key_enabled = true

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  provider = aws.security_log
  bucket   = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "main" {
  provider = aws.security_log
  bucket   = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "main" {
  provider = aws.security_log
  bucket   = aws_s3_bucket.main.id

  depends_on = [aws_s3_bucket_public_access_block.main]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.main.arn
      },
      {
        Sid    = "AWSCloudTrailWriteOrganization"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = "s3:PutObject"
        Resource = [
          "${aws_s3_bucket.main.arn}/AWSLogs/${var.aws_management_account_id}/*",
          "${aws_s3_bucket.main.arn}/AWSLogs/${data.aws_organizations_organization.current.id}/*"
        ]
        Condition = {
          StringEquals = {
            "aws:SourceArn" = "arn:aws:cloudtrail:eu-west-2:${var.aws_management_account_id}:trail/organization-security-trail"
            "s3:x-amz-acl"  = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

