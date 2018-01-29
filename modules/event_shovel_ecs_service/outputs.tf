output "task_arn" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_ecs_task_definition.ecs_task.*.arn, list("")), 0)}"
}
