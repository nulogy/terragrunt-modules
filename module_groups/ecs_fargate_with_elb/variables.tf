variable "container_port" {}
variable "desired_capacity" { default = "" }
variable "environment_name" {}
variable "max_size" { default = "" }
variable "min_size" { default = "" }
variable "private_ecs_subnets" { type = "list" }
variable "vpc_cidr" {}
