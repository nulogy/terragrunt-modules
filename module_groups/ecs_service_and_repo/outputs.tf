output "ecr_url" {
  value = "${module.ecr.ecr_url}"
}

output "ecs_service_name" {
  value = "${module.ecs_service.ecs_service_name}"
}

output "task_arn" {
  value = "${module.ecs_service.task_arn}"
}