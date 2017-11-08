data "aws_acm_certificate" "acm_region_cert" {
  domain   = "${var.cert_domain}"
}