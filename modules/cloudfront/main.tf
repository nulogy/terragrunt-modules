locals {
  custom_error_response_codes = [for c in var.custom_error_response : c.error_code]

  origin = concat(
    [
      {
        domain_name = aws_s3_bucket.default.bucket_regional_domain_name
        origin_id   = "default"

        s3_origin_config = {
          origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
        }
      }
    ],
    var.origin
  )

  ordered_cache_behavior = concat(
    var.ordered_cache_behavior,
    [
      {
        path_pattern     = "/500.html"
        target_origin_id = "default"
      }
    ]
  )

  tags = merge(
    {
      Name           = "${var.environment_name} CloudFront Distribution"
      resource_group = var.environment_name
    },
    var.tags,
  )
}

resource "aws_cloudfront_distribution" "this" {
  aliases             = var.aliases
  default_root_object = var.default_root_object
  enabled             = true
  price_class         = "PriceClass_100"
  web_acl_id          = var.web_acl_id
  tags                = local.tags

  dynamic "origin" {
    for_each = local.origin
    iterator = i

    content {
      domain_name = i.value.domain_name
      origin_id   = i.value.origin_id

      dynamic "custom_header" {
        for_each = lookup(i.value, "custom_header", [])

        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }

      # default custom origin config if neither custom_origin_config or s3_origin_config are specified
      dynamic "custom_origin_config" {
        for_each = length(keys(lookup(i.value, "custom_origin_config", {}))) > 0 || length(keys(lookup(i.value, "s3_origin_config", {}))) > 0 ? [] : [true]

        content {
          http_port                = 80
          https_port               = 443
          origin_read_timeout      = 60
          origin_keepalive_timeout = 5
          origin_protocol_policy   = "https-only"
          origin_ssl_protocols     = ["TLSv1.1", "TLSv1.2"]
        }
      }

      dynamic "custom_origin_config" {
        for_each = length(keys(lookup(i.value, "custom_origin_config", {}))) > 0 ? [i.value.custom_origin_config] : []

        content {
          http_port                = lookup(custom_origin_config.value, "http_port", 80)
          https_port               = lookup(custom_origin_config.value, "https_port", 443)
          origin_read_timeout      = lookup(custom_origin_config.value, "origin_read_timeout", 60)
          origin_keepalive_timeout = lookup(custom_origin_config.value, "origin_keepalive_timeout", 5)
          origin_protocol_policy   = lookup(custom_origin_config.value, "origin_protocol_policy", "https-only")
          origin_ssl_protocols     = ["TLSv1.1", "TLSv1.2"]
        }
      }

      dynamic "s3_origin_config" {
        for_each = length(keys(lookup(i.value, "s3_origin_config", {}))) > 0 ? [i.value.s3_origin_config] : []

        content {
          origin_access_identity = lookup(s3_origin_config.value, "origin_access_identity", null)
        }
      }
    }
  }

  dynamic "default_cache_behavior" {
    for_each = [var.default_cache_behavior]
    iterator = i

    content {
      allowed_methods        = lookup(i.value, "allowed_methods", ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"])
      cached_methods         = lookup(i.value, "cached_methods", ["GET", "HEAD"])
      compress               = lookup(i.value, "compress", null)
      default_ttl            = lookup(i.value, "default_ttl", 0)
      max_ttl                = lookup(i.value, "max_ttl", 0)
      min_ttl                = lookup(i.value, "min_ttl", 0)
      target_origin_id       = var.maintenance_mode ? "default" : i.value.target_origin_id
      viewer_protocol_policy = lookup(i.value, "viewer_protocol_policy", "redirect-to-https")

      dynamic "forwarded_values" {
        for_each = [lookup(i.value, "forwarded_values", {})]

        content {
          query_string = lookup(forwarded_values.value, "query_string", !var.maintenance_mode)
          headers      = lookup(forwarded_values.value, "headers", var.maintenance_mode ? ["None"] : ["*"])

          dynamic "cookies" {
            for_each = [lookup(forwarded_values.value, "cookies", {})]

            content {
              forward = lookup(cookies.value, "forward", var.maintenance_mode ? "none" : "all")
            }
          }
        }
      }
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = local.ordered_cache_behavior
    iterator = i

    content {
      allowed_methods        = lookup(i.value, "allowed_methods", ["GET", "HEAD", "OPTIONS"])
      cached_methods         = lookup(i.value, "cached_methods", ["GET", "HEAD", "OPTIONS"])
      compress               = lookup(i.value, "compress", true)
      default_ttl            = lookup(i.value, "default_ttl", null)
      max_ttl                = lookup(i.value, "max_ttl", null)
      min_ttl                = lookup(i.value, "min_ttl", null)
      path_pattern           = i.value.path_pattern
      target_origin_id       = i.value.target_origin_id
      viewer_protocol_policy = lookup(i.value, "viewer_protocol_policy", "redirect-to-https")

      dynamic "forwarded_values" {
        for_each = [lookup(i.value, "forwarded_values", {})]

        content {
          query_string = lookup(forwarded_values.value, "query_string", false)
          headers      = lookup(forwarded_values.value, "headers", null)

          dynamic "cookies" {
            for_each = [lookup(forwarded_values.value, "cookies", {})]

            content {
              forward = lookup(cookies.value, "forward", "none")
            }
          }
        }
      }
    }
  }

  dynamic "custom_error_response" {
    for_each = var.maintenance_mode ? [400, 403, 404, 405, 414, 416] : []
    iterator = i

    content {
      error_code         = i.value
      response_code      = 503
      response_page_path = "/maintenance.html"
    }
  }

  dynamic "custom_error_response" {
    for_each = setsubtract([500, 501, 502, 503, 504], local.custom_error_response_codes)
    iterator = i

    content {
      error_code         = i.value
      response_code      = i.value
      response_page_path = "/500.html"
    }
  }

  dynamic "custom_error_response" {
    for_each = var.maintenance_mode ? [] : var.custom_error_response
    iterator = i

    content {
      error_caching_min_ttl = lookup(i.value, "error_caching_min_ttl", null)
      error_code            = i.value.error_code
      response_code         = i.value.response_code
      response_page_path    = i.value.response_page_path
    }
  }

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.logs.bucket_domain_name
    prefix          = null
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn      = lookup(var.viewer_certificate, "acm_certificate_arn", null)
    minimum_protocol_version = lookup(var.viewer_certificate, "minimum_protocol_version", "TLSv1.2_2018")
    ssl_support_method       = lookup(var.viewer_certificate, "ssl_support_method", "sni-only")
  }
}

resource "aws_cloudfront_origin_access_identity" "default" {
  comment = "${var.environment_name} origin access identity"
}
