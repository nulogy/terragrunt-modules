output "ecs_service_name" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_ecs_service.ecs_service.*.name, list("")), 0)}"
}

output "task_arn" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_ecs_task_definition.ecs_task.*.arn, list("")), 0)}"
}

output "iam_id" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_iam_role.ecs_taskrole.*.id, list("")), 0)}"
}
