output "dns_name" {
  value = module.public_load_balancer.dns_name
}

output "ecs_service_name" {
  value = module.ecs_service_fargate_elb.ecs_service_name
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

