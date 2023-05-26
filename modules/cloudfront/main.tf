locals {
  tags = merge(
    {
      Name           = "${var.environment_name} CloudFront Distribution"
      resource_group = var.environment_name
    },
    var.tags,
  )

  origin = concat(
    [
     {
       domain_name = aws_s3_bucket_website_configuration.cloudfront.website_endpoint
       origin_id   = "maintenance-errors"
     }
    ],
    var.origin
  )

  maintenance = var.default_origin_id == "maintenance-errors"
}

resource "aws_cloudfront_distribution" "this" {
  aliases     = var.aliases
  enabled     = true
  price_class = "PriceClass_100"
  web_acl_id  = var.web_acl_id
  tags        = local.tags

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.logs.bucket_domain_name
    prefix          = null
  }

  dynamic "origin" {
    for_each = local.origin
    iterator = i

    content {
      domain_name = i.value.domain_name
      origin_id   = i.value.origin_id

      custom_origin_config {
        http_port                = 80
        https_port               = 443
        origin_read_timeout      = 60
        origin_keepalive_timeout = 5
        origin_protocol_policy   = "https-only"
        origin_ssl_protocols     = ["TLSv1.1", "TLSv1.2"]
      }

      dynamic "custom_header" {
        for_each = lookup(i.value, "custom_header", [])

        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.default_origin_id

    forwarded_values {
      query_string = true
      headers      = [local.maintenance ? "None" : "*"]

      cookies {
        forward = local.maintenance ? "none" : "all"
      }
    }
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    viewer_protocol_policy = "redirect-to-https"
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behavior
    iterator = i

    content {
      path_pattern           = i.value.path_pattern
      target_origin_id       = i.value.target_origin_id
      viewer_protocol_policy = lookup(i.value, "viewer_protocol_policy", "redirect-to-https")
      allowed_methods        = lookup(i.value, "allowed_methods", ["GET", "HEAD", "OPTIONS"])
      cached_methods         = lookup(i.value, "cached_methods", ["GET", "HEAD", "OPTIONS"])
      compress               = lookup(i.value, "compress", true)
      min_ttl                = lookup(i.value, "min_ttl", null)
      default_ttl            = lookup(i.value, "default_ttl", null)
      max_ttl                = lookup(i.value, "max_ttl", null)

      forwarded_values {
        query_string = lookup(i.value, "query_string", false)

        cookies {
          forward = lookup(i.value, "cookies_forward", "none")
        }
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = lookup(var.viewer_certificate, "acm_certificate_arn", null)
    minimum_protocol_version = lookup(var.viewer_certificate, "minimum_protocol_version", "TLSv1.2_2018")
    ssl_support_method       = lookup(var.viewer_certificate, "ssl_support_method", "sni-only")
  }

  custom_error_response {
    # This case handles GET calls made during maintenance
    error_code         = 404
    response_code      = local.maintenance ? 503 : 0
    response_page_path = local.maintenance ? "/maintenance.html" : ""
  }

  custom_error_response {
    # This case handles POST, PUT and DELETE calls made during maintenance
    error_code         = 405
    response_code      = local.maintenance ? 503 : 0
    response_page_path = local.maintenance ? "/maintenance.html" : ""
  }

  custom_error_response {
    # This case handles OPTIONS calls made during maintenance
    error_code         = 400
    response_code      = local.maintenance ? 503 : 0
    response_page_path = local.maintenance ? "/maintenance.html" : ""
  }

  custom_error_response {
    error_code         = 504
    response_code      = 504
    response_page_path = "/500.html"
  }

  custom_error_response {
    error_code         = 503
    response_code      = 503
    response_page_path = "/503.html"
  }

  custom_error_response {
    error_code         = 502
    response_code      = 502
    response_page_path = "/500.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
}