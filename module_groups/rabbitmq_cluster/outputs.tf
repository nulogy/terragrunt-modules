output rabbitmq_autoscaling_group_name {
  value = "${aws_cloudformation_stack.rabbitmq.outputs["AsgName"]}"
}
