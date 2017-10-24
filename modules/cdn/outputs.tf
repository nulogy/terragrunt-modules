output "cloudfront" {
  value = "${aws_cloudfront_distribution.cf_distribution.domain_name}"
}
