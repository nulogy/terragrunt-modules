output "ecs_service_name" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_ecs_service.ecs_service.*.name, list("")), 0)}"
}

output "task_arn" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_ecs_task_definition.ecs_task.*.arn, list("")), 0)}"
}

output "ecs_role_name_prefix" {
  value = "${local.ecs_role_name_prefix}"
}
