variable "desired_capacity" { default = "" }
variable "ec2_public_key" {}
variable "ecs_ami_version" { default = "" }
variable "environment_name" {}
variable "lc_instance_type" {}
variable "max_size" { default = "" }
variable "min_size" { default = "" }
variable "health_check_type" { default = "EC2" }
variable "peer_account_id" { default = "" }
variable "peer_vpc_id" { default = "" }
variable "peer_vpc_cidr" { default = "" }
variable "peer_auto_accept" { default = "" }
variable "private_ecs_subnets" { type = "list" }
variable "public_subnets" { type = "list" }
variable "skip" { default = "" }
variable "vpc_cidr" {}
