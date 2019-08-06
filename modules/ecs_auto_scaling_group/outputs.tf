output "autoscaling_group_name" {
  value = element(concat(aws_autoscaling_group.asg.*.name, [""]), 0)
}

