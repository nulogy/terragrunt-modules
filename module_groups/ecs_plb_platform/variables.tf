variable "cert_domain" {}
variable "desired_capacity" { default = "" }
variable "ec2_public_key" {}
variable "ecs_ami_version" { default = "" }
variable "environment_name" {}
variable "lc_instance_type" {}
variable "max_size" { default = "" }
variable "min_size" { default = "" }
variable "peer_account_id" { default = "" }
variable "peer_vpc_id" { default = "" }
variable "peer_vpc_cidr" { default = "" }
variable "prefix_plb_subdomain" { default = "" }
variable "private_ecs_subnets" { type = "list" }
variable "public_subnets" { type = "list" }
variable "route53_domain" { default = "" }
variable "route53_subdomain" { default = "" }
variable "skip" { default = "" }
variable "vpc_cidr" {}
