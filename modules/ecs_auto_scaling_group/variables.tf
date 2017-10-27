variable "desired_capacity" {}
variable "ecs_ami_version" {}
variable "ecs_cluster_name" {}
variable "ec2_subnet_ids" { type = "list" }
variable "lc_instance_type" {}
variable "environment_name" {}
variable "max_size" {}
variable "min_size" {}
variable "public_key" {}
variable "vpc_cidr" {}
variable "vpc_id" {}
