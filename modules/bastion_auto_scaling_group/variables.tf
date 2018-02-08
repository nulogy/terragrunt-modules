variable "ecs_ami_version" {}
variable "ec2_subnet_ids" { type = "list" }
variable "lc_instance_type" { default = "" }
variable "environment_name" {}
variable "office_ip" { default = "" }
variable "public_key" {}
variable "skip" { default = "" }
variable "vpc_cidr" {}
variable "vpc_id" {}
