//output "ecs_service_name" {
//  value = module.ecs_service_fargate_elb.ecs_service_name
//}

output "task_role_id" {
  value = module.ecs_service_fargate_elb.task_role_id
}

//output "target_group_arn" {
//  value = module.public_load_balancer.target_group_arn
//}

output "log_group_name" {
  value = module.log_group.log_group_name
}

output "log_group_arn" {
  value = module.log_group.log_group_arn
}

//output "lb_listener_arns" {
//  value = module.public_load_balancer.aws_lb_listener
//}

output "dns_name_tmp" {
  value = module.public_load_balancer_tmp.dns_name
}
