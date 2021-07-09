output "dns_name" {
  value = module.public_load_balancer.dns_name
}

output "ecs_service_name" {
  value = module.ecs_service_fargate_codedeploy.ecs_service_name
}

output "task_role_id" {
  value = module.ecs_service_fargate_codedeploy.task_role_id
}

output "target_group_arn" {
  value = module.public_load_balancer.target_group_arn
}

output "log_group_name" {
  value = module.log_group.log_group_name
}

output "log_group_arn" {
  value = module.log_group.log_group_arn
}

output "lb_listener_arns" {
  value = module.public_load_balancer.aws_lb_listener
}
