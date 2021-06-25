output "dns_name" {
  value = module.public_load_balancer.dns_name
}

output "ecs_service_name" {
  value = module.ecs_service_fargate_elb.ecs_service_name
}

output "ecs_service_arn" {
  value = module.ecs_service_fargate_elb.ecs_service_arn
}

output "task_role_id" {
  value = module.ecs_service_fargate_elb.task_role_id
}

output "target_group_green_arn" {
  value = module.public_load_balancer.target_group_green_arn
}

output "target_group_green_name" {
  value = module.public_load_balancer.target_group_green_name
}

output "target_group_blue_arn" {
  value = module.public_load_balancer.target_group_blue_arn
}

output "target_group_blue_name" {
  value = module.public_load_balancer.target_group_blue_name
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
