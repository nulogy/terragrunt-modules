provider "aws" {
  region = "us-east-1"
  profile = "${var.aws_profile}"
  alias  = "us-east-1"
  version = "~> 2.0"
}

data "aws_acm_certificate" "acm_cf_cert" {
  provider = "aws.us-east-1"
  domain   = "${var.cert_domain}"
}
