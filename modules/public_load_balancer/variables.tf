variable "alb_subnets" { type = "list" }
variable "environment_name" {}
variable "region_cert_arn" {}
variable "route_53_domain" { default = "" }
variable "route_53_subdomain" { default = "" }
variable "vpc_id" {}
