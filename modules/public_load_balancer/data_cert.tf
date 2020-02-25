data "aws_acm_certificate" "acm_region_cert" {
  count = length(var.skip) > 0 ? 0 : (length(var.lb_cert_arn) > 0 ? 0 : 1)

  domain = var.cert_domain
}

