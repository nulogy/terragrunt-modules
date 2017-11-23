output "task_arn" {
  value = "${aws_ecs_task_definition.ecs_task.arn}"
}