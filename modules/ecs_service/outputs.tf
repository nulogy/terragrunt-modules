output "ecs_service_name" {
  value = "${aws_ecs_service.ecs_service.name}"
}

output "task_arn" {
  value = "${aws_ecs_task_definition.ecs_task.arn}"
}