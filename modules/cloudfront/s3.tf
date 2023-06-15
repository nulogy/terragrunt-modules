resource "aws_s3_bucket" "logs" {
  bucket_prefix            = "${var.environment_name}-cf-logs-"
  force_destroy            = "true"
  tags                     = var.tags
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "expiration"
    status = "Enabled"

    expiration {
      days = 30
    }

    noncurrent_version_expiration {
      noncurrent_days = 1
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "cloudfront" {
  bucket_prefix = "${var.environment_name}-cf-"
  force_destroy = "true"
  tags          = var.tags
}

resource "aws_s3_bucket_ownership_controls" "cloudfront" {
  bucket = aws_s3_bucket.cloudfront.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_website_configuration" "cloudfront" {
  bucket = aws_s3_bucket.cloudfront.id

  index_document {
    suffix = "no file - deliberately cause a 404 which gets transformed into a 503 by cloudfront"
  }

  error_document {
    key = "maintenance.html"
  }
}

resource "aws_s3_bucket_versioning" "cloudfront" {
  bucket = aws_s3_bucket.cloudfront.id

  versioning_configuration {
    status = "Enabled"
  }
}

data "aws_iam_policy_document" "cloudfront" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.cloudfront.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.this.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudfront" {
  bucket = aws_s3_bucket.cloudfront.id
  policy = data.aws_iam_policy_document.cloudfront.json
}

resource "aws_s3_bucket_public_access_block" "cloudfront" {
  bucket = aws_s3_bucket.cloudfront.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_object" "page_500" {
  bucket       = aws_s3_bucket.cloudfront.id
  content_type = "text/html"
  key          = "500.html"
  source       = "${path.module}/files/500.html"
  etag         = filemd5("${path.module}/files/500.html")
}

resource "aws_s3_bucket_object" "page_404" {
  bucket       = aws_s3_bucket.cloudfront.id
  content_type = "text/html"
  key          = "404.html"
  source       = "${path.module}/files/404.html"
  etag         = filemd5("${path.module}/files/404.html")
}

resource "aws_s3_bucket_object" "maintenance" {
  bucket       = aws_s3_bucket.cloudfront.id
  content_type = "text/html"
  key          = "maintenance.html"
  source       = "${path.module}/files/maintenance.html"
  etag         = filemd5("${path.module}/files/maintenance.html")
}
