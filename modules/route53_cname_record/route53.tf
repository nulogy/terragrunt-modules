resource "aws_route53_record" "route53_record" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name    = "${var.subdomain}"
  records = ["${var.target_domain}"]
  ttl     = "60"
  type    = "CNAME"
  zone_id = "${data.aws_route53_zone.route53_zone.id}"
}

data "aws_route53_zone" "route53_zone" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name = "${var.domain}"
}
