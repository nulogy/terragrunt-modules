output "autoscaling_group_name" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_autoscaling_group.asg.*.name, list("")), 0)}"
}
