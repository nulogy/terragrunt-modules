variable "alb_subnets" {
  type = list(string)
}

variable "cert_domain" {
}

variable "environment_name" {
}

variable "environment_key" {
  description = "This should be less than 20 characters so that it can be reliably used as a backend key where character count is limited."
}

variable "health_check_path" {
  default = "/"
}

variable "health_check_timeout" {
  description = "The amount of time, in seconds, during which no response from a target means a failed health check."
  default     = 5
}

variable "skip" {
  default = ""
}

variable "vpc_id" {
}

variable "slow_start" {
  description = "Number of seconds to bleed traffic to the app. Useful for slow Rails startup time apps (like Packmanager)."
  default     = 0
}

variable "deregistration_delay" {
  description = "The amount of time, in seconds, for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused . The range is 0-3600 seconds."
  default     = 120
}

variable "stickiness_enabled" {
  description = "Boolean to turn on stickiness for the ALB Target Group. Turn on to allow CSS/JS to go to the same server as the request."
  default     = false
}

variable "stickiness_duration" {
  description = "The time period, in seconds, to use sticky Cookie. Does nothing unless stickiness_enabled = true."
  default     = "600"
}

variable "target_type" {
  description = "Set this to `ip` for Fargate or other exceptional cases, otherwise leave it as the default"
  default     = "instance"
}

variable "port" {
  description = "The port on which targets receive traffic"
  default     = "80"
}

variable "lb_maintenance_mode" {
  description = "Sets to true if we are in our maintenance window, so the LB can serve a static page to our customers."
  default     = false
}

variable "lb_maintenance_mode_content_type" {
  description = "Maintenance page content type."
  default     = "text/plain"
}

variable "lb_maintenance_mode_page_content" {
  description = "Maintenance page path. Its contents are going to be served while in the maintenance window. Always used a minified version because currently AWS LBs only supports 1024 bytes static pages."
  default     = "Sorry: We are under maintenance. Please come back later."
}

variable "lb_maintenance_mode_status_code" {
  description = "Maintenance page HTTP status code."
  default     = 503
}

variable "internal" {
  description = "An Internet-facing load balancer routes requests from clients over the Internet to targets. An internal load balancer routes requests from clients to targets using private IP addresses."
  default     = false
}

variable "ip_address_type" {
  description = "ipv4 or dualstack for ipv6 support"
  default     = "ipv4"
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "lb_cert_arn" {
  default = ""
}
