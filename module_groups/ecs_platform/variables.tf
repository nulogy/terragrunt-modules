
variable "environment_name" {}
variable "route_53_domain" {}
variable "route_53_subdomain" {}

variable "vpc_cidr" {}

variable "ec2_public_key" {}
variable "ecs_ami_version" {}
variable "lc_instance_type" {}

variable "private_ecs_subnets" { type = "list" }
variable "public_subnets" { type = "list" }

variable "acm_region_cert_arn" {}