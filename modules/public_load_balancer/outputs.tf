output "target_group_arn" {
  value = "${aws_alb_target_group.target_group.arn}"
}

output "zone_id" {
  value = "${aws_alb.public_load_balancer.zone_id}"
}

output "dns_name" {
  value = "${aws_alb.public_load_balancer.dns_name}"
}