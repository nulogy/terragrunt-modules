variable "desired_capacity" { default = "" }
variable "ec2_public_key" {}
variable "ecs_ami_version" { default = "" }
variable "environment_name" {}
variable "lc_instance_type" {}
variable "max_size" { default = "" }
variable "min_size" { default = "" }
variable "private_ecs_subnets" { type = "list" }
variable "public_subnets" { type = "list" }
variable "skip" { default = "" }
variable "vpc_cidr" {}

