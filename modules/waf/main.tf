resource "aws_wafv2_web_acl" "main" {
  name  = var.environment_name
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "geoMatchForLabels"
    priority = 10

    action {
      count {}
    }

    statement {
      not_statement {
        statement {
          geo_match_statement {
            country_codes = var.country_codes_allow_list
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.environment_name}-waf-geoMatchForLabels"
      sampled_requests_enabled   = true
    }
  }

  dynamic "rule" {
    for_each = length(var.country_codes_block_list) > 0 ? [""] : []
    iterator = i

    content {
      name     = "labelMatchForCountryBlock"
      priority = 20

      dynamic "action" {
        for_each = var.enable_block ? [""] : []
        iterator = i

        content {
          block {}
        }
      }

      dynamic "action" {
        for_each = var.enable_block ? [] : [""]
        iterator = i

        content {
          count {}
        }
      }

      dynamic "statement" {
        for_each = length(var.country_codes_block_list) == 1 ? var.country_codes_block_list : []

        content {
          label_match_statement {
            scope = "LABEL"
            key   = "awswaf:clientip:geo:country:${statement.value}"
          }
        }
      }

      dynamic "statement" {
        for_each = length(var.country_codes_block_list) > 1 ? [""] : []
        iterator = j

        content {
          or_statement {
            dynamic "statement" {
              for_each = var.country_codes_block_list

              content {
                label_match_statement {
                  scope = "LABEL"
                  key   = "awswaf:clientip:geo:country:${statement.value}"
                }
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${var.environment_name}-waf-labelMatchForCountryBlock"
        sampled_requests_enabled   = true
      }
    }
  }

  dynamic "rule" {
    for_each = length(var.region_codes_block_list) > 0 ? [""] : []
    iterator = i

    content {
      name     = "labelMatchForRegionBlock"
      priority = 40

      dynamic "action" {
        for_each = var.enable_block ? [""] : []
        iterator = i

        content {
          block {}
        }
      }

      dynamic "action" {
        for_each = var.enable_block ? [] : [""]
        iterator = i

        content {
          count {}
        }
      }

      dynamic "statement" {
        for_each = length(var.region_codes_block_list) == 1 ? var.region_codes_block_list : []

        content {
          label_match_statement {
            scope = "LABEL"
            key   = "awswaf:clientip:geo:region:${statement.value}"
          }
        }
      }

      dynamic "statement" {
        for_each = length(var.region_codes_block_list) > 1 ? [""] : []
        iterator = j

        content {
          or_statement {
            dynamic "statement" {
              for_each = var.region_codes_block_list

              content {
                label_match_statement {
                  scope = "LABEL"
                  key   = "awswaf:clientip:geo:region:${statement.value}"
                }
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${var.environment_name}-waf-labelMatchForRegionBlock"
        sampled_requests_enabled   = true
      }
    }
  }

  tags = var.tags

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "${var.environment_name}-waf-default"
    sampled_requests_enabled   = false
  }
}