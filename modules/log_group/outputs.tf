output "log_group_name" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_cloudwatch_log_group.log_group.*.name, list("")), 0)}"
}

output "log_group_arn" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_cloudwatch_log_group.log_group.*.arn, list("")), 0)}"
}
