resource "aws_route53_record" "route53_record" {
  name = "${var.route_53_subdomain}"
  type = "A"
  zone_id = "${data.aws_route53_zone.route53_zone.id}"
  alias {
    evaluate_target_health = false
    name = "${aws_cloudfront_distribution.cf_distribution.domain_name}"
    zone_id = "${aws_cloudfront_distribution.cf_distribution.hosted_zone_id}"
  }
}

data "aws_route53_zone" "route53_zone" {
  name = "${var.route_53_domain}"
}
