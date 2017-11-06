variable "allocated_storage" {}
variable "db_name" {}
variable "db_password" {}
variable "engine_version" {}
variable "environment_name" {}
variable "instance_class" {}
variable "parameter_group_name" {}
variable "private_rds_subnets" { type = "list" }
variable "production_mode" {}
variable "db_username" {}
variable "vpc_cidr" {}
variable "vpc_id" {}