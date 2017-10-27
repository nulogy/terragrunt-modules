resource "aws_route53_record" "plb_route53_record" {
  name = "plb-${var.route_53_subdomain}"
  type = "A"
  zone_id = "${data.aws_route53_zone.route53_zone.id}"
  alias {
    evaluate_target_health = false
    name = "${lower(aws_alb.public_load_balancer.dns_name)}"
    zone_id = "${aws_alb.public_load_balancer.zone_id}"
  }
}

data "aws_route53_zone" "route53_zone" {
  name = "${var.route_53_domain}"
}
