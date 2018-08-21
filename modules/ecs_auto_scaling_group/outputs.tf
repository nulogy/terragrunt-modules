output "autoscaling_group_name" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_cloudformation_stack.asg.*.outputs.AsgName, list("")), 0)}"
}
