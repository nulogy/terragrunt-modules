variable "aws_lb_listener" {
  description = "The resource name for the load balancer listener."
}

variable "ecs_cluster_name" {
  description = "Cluster to put the Fargate container in. Add it to the same one as any background workers."
}

variable "ecs_service_name" {
  description = "Name of the service."
}

variable "environment_name" {
  description = "Environment name. Used for tagging."
}

variable "target_group_blue_name" {
  description = "The name of the blue target group used for blue-green deployment."
}

variable "target_group_green_name" {
  description = "The name of the green target group used for blue-green deployment."
}
