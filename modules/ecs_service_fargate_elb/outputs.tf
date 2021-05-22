output "ecs_service_name" {
  value = aws_ecs_service.ecs_service.name
}

output "ecs_service_arn" {
  value = aws_ecs_service.ecs_service.id
}

output "task_arn" {
  value = aws_ecs_task_definition.ecs_task.arn
}

output "task_role_id" {
  value = aws_iam_role.ecs_taskrole.id
}

