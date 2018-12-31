output "target_group_arn" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_lb_target_group.target_group.*.arn, list("")), 0)}"
}

output "aws_lb_listener" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_lb_listener.public_lb_listener.*.arn, list("")), 0)}"
}

output "zone_id" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_lb.public_load_balancer.*.zone_id, list("")), 0)}"
}

output "dns_name" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_lb.public_load_balancer.*.dns_name, list("")), 0)}"
}
