provider "aws" {
  region = "us-east-1"
  alias  = "us-east-1"
}

data "aws_acm_certificate" "acm_cf_cert" {
  provider = "aws.us-east-1"
  domain   = "${var.cert_domain}"
}
