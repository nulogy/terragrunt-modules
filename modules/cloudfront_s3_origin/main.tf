data "aws_acm_certificate" "acm_cf_cert" {
  domain = var.source_cloudfront_cert_domain
}

resource "aws_cloudfront_distribution" "cf_redirect_distribution" {
  tags = {
    Name           = "${var.environment_name} Redirect"
    resource_group = var.environment_name
  }

  comment = "${var.environment_name} Redirect"
  enabled = true

  aliases = [
    var.source_domain_name]

  origin {
    domain_name = var.s3_website_endpoint
    origin_id   = var.s3_bucket_regional_domain_name

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_read_timeout      = 60
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_ssl_protocols     = ["TLSv1.1", "TLSv1.2"]
    }
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    minimum_protocol_version = "TLSv1.2_2021"
    acm_certificate_arn      = data.aws_acm_certificate.acm_cf_cert.arn
    ssl_support_method       = "sni-only"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_bucket_regional_domain_name

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    viewer_protocol_policy = "redirect-to-https"
  }
}
