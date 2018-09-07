variable "alb_subnets" { type = "list" }
variable "cert_domain" {}
variable "environment_name" {}
variable "health_check_path" { default = "/" }
variable "skip" { default = "" }
variable "vpc_id" {}

variable "stickiness_enabled" {
  description = "Boolean to turn on stickiness for the ALB Target Group. Turn on to allow CSS/JS to go to the same server as the request."
  default = false
}

variable "stickiness_duration" {
  description = "The time period, in seconds, to use sticky Cookie. Does nothing unless stickiness_enabled = true."
  default = "600"
}
