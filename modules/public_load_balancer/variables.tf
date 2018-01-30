variable "alb_subnets" { type = "list" }
variable "cert_domain" {}
variable "environment_name" {}
variable "health_check_path" { default = "/" }
variable "skip" { default = "" }
variable "vpc_id" {}
