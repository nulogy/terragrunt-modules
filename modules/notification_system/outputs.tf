output "topic_arn" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_sns_topic.topic.*.arn, list("")), 0)}"
}
