variable "cert_domain" {}
variable "ec2_public_key" {}
variable "ecs_ami_version" { default = "2017.03.g" }
variable "environment_name" {}
variable "lc_instance_type" {}
variable "prefix_plb_subdomain" { default = "" }
variable "private_ecs_subnets" { type = "list" }
variable "public_subnets" { type = "list" }
variable "route53_domain" { default = "" }
variable "route53_subdomain" { default = "" }
variable "skip" { default = "" }
variable "skip_route53" { default = "" }
variable "vpc_cidr" {}
