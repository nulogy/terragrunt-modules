locals {
  subdomain = "${length(var.subdomain) > 0 ? "${var.subdomain}" : "${var.domain}"}"
}

resource "aws_route53_record" "route53_record" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name = "${local.subdomain}"
  type = "A"
  zone_id = "${data.aws_route53_zone.route53_zone.id}"
  alias {
    evaluate_target_health = false
    name = "${lower(var.target_domain)}"
    zone_id = "${var.target_zone_id}"
  }
}

data "aws_route53_zone" "route53_zone" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name = "${var.domain}"
}
