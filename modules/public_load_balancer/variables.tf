variable "alb_subnets" { type = "list" }
variable "cert_domain" {}
variable "environment_name" {}
variable "health_check_path" { default = "/" }
variable "skip" { default = "" }
variable "vpc_id" {}

variable "slow_start" {
  description = "Number of seconds to bleed traffic to the app. Useful for slow Rails startup time apps (like Packmanager)."
  default = 0
}

variable "stickiness_enabled" {
  description = "Boolean to turn on stickiness for the ALB Target Group. Turn on to allow CSS/JS to go to the same server as the request."
  default = false
}

variable "stickiness_duration" {
  description = "The time period, in seconds, to use sticky Cookie. Does nothing unless stickiness_enabled = true."
  default = "600"
}

variable "target_type" {
  description = "Set this to `ip` for Fargate or other exceptional cases, otherwise leave it as the default"
  default = "instance"
}

variable "port" {
  description = "The port on which targets receive traffic"
  default = "80"
}
