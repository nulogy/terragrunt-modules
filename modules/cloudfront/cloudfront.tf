resource "aws_cloudfront_distribution" "cf_distribution" {
  tags {
    Name = "${var.environment_name} Cloud Front Distribution"
    resource_group = "${var.environment_name}"
  }

  enabled = true
  aliases = ["${var.route_53_subdomain}.${var.route_53_domain}"]

  origin {
    domain_name = "${var.app_fqdn}"
    origin_id = "${var.environment_name}-app"

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_read_timeout = 30
      origin_keepalive_timeout = 5
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1.1", "TLSv1.2"]
    }
  }

  origin {
    domain_name = "${var.assets_bucket_domain}"
    origin_id = "${var.environment_name}-staticAssets"
  }

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "${var.environment_name}-app"

    "forwarded_values" {
      query_string = true
      headers = ["*"]

      "cookies" {
        forward = "all"
      }
    }
    default_ttl = 0
    max_ttl = 0
    min_ttl = 0
    viewer_protocol_policy = "redirect-to-https"
  }

  cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "${var.environment_name}-staticAssets"
    path_pattern = "${var.static_assets_path}"
    compress = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }

  cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "${var.environment_name}-staticAssets"
    path_pattern = "*.txt"
    compress = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 0
    max_ttl = 0
  }

  cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "${var.environment_name}-staticAssets"
    path_pattern = "favicon.ico"
    compress = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    minimum_protocol_version = "TLSv1.1_2016"
    acm_certificate_arn = "${var.cf_cert_arn}"
    ssl_support_method = "sni-only"
  }
}
