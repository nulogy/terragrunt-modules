output "autoscaling_group_name" {
  value = "${aws_cloudformation_stack.asg.outputs["AsgName"]}"
}
