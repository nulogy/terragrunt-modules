variable "desired_capacity" {}
variable "default_cooldown" { default = 300 }
variable "ecs_ami_version" {}
variable "ecs_cluster_name" {}
variable "ec2_subnet_ids" { type = "list" }
variable "lc_instance_type" {}
variable "environment_name" {}
variable "max_size" {}
variable "min_size" {}
variable "health_check_type" {}
variable "public_key" {}
variable "skip" { default = "" }
variable "vpc_cidr" {}
variable "vpc_id" {}
