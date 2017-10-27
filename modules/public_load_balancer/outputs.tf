output "public_load_balancer_fqdn" {
  value = "${aws_route53_record.plb_route53_record.fqdn}"
}

output "target_group_arn" {
  value = "${aws_alb_target_group.target_group.arn}"
}