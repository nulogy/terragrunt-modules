resource "aws_route53_record" "route53_record" {
  name    = var.subdomain
  type    = "A"
  zone_id = data.aws_route53_zone.route53_zone.id

  alias {
    evaluate_target_health = false
    name                   = lower(module.amqp_load_balancer.aws_elb_dns_name)
    zone_id                = module.amqp_load_balancer.aws_elb_zone_id
  }
}

data "aws_route53_zone" "route53_zone" {
  name = var.domain
}

