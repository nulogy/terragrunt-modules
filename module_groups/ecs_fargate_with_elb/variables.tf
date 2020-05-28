variable "ecs_cluster_name" {
  description = "Cluster to put the Fargate container in. Add it to the same one as any background workers."
}

variable "cert_domain" {
  description = "Certificate for the load balancer to use. eg. *.packmanager-test.nulogy.com"
}

variable "cpu" {
  description = "How much CPU to allocate per container. 1024 = 1 vCPU."
}

variable "command" {
  description = "The entrypoint command for the Fargate containers. Should run a web server."
  type        = list(string)
}

variable "container_port" {
  description = "Set the container port for access to the container via the ELB. This should match the port that the web server listens to."
  default     = 3000
}

variable "desired_count" {
  description = "How many docker containers to run. Should be 2+"
  default     = 2
}

variable "docker_image_name" {
  description = "The docker container that we plan to run. This determines what version of the code is live!"
}

variable "envars" {
  description = ""
}

variable "environment_name" {
  description = "Environment name. Used for tagging."
}

variable "health_check_path" {
  description = "The path that the Load Balancer will check. If it does not have a 200 OK response, then the container is killed."
}

variable "health_check_timeout" {
  description = "The amount of time, in seconds, during which no response from a worker means a failed health check."
  default     = 5
}

variable "internal" {
  description = "An Internet-facing load balancer routes requests from clients over the Internet to targets. An internal load balancer routes requests from clients to targets using private IP addresses."
  default     = false
}

variable "kms_key_id" {
}

variable "memory" {
}

variable "param_store_namespace" {
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "security_group_name" {
  description = "Manually set the security group name. This exists as a bridge to work around a value that was unfortunately hardcoded in versions <= 5.0.0. When writing new code, you can probably ignore this and use the default blank string."
  default     = ""
}

variable "service_name" {
}

variable "deregistration_delay" {
  description = "The amount of time, in seconds, for Elastic Load Balancing to wait before changing the state of a deregistering task from draining to unused. The range is 0-3600 seconds."
  default     = 120
}

variable "slow_start" {
  description = "Number of seconds to bleed traffic to the app. Useful for slow Rails startup time apps (like Packmanager)."
  default     = 0
}

variable "stickiness_enabled" {
  description = "Boolean to turn on stickiness for the ALB Target Group. Turn on to allow CSS/JS to go to the same server as the request."
  default     = false
}

variable "vpc_cidr" {
}

variable "vpc_id" {
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
  description = "Maintenance page content. The most common scenario is to specify some HTML code here."
  default     = "Sorry: We are under maintenance. Please come back later."
}

variable "lb_maintenance_mode_status_code" {
  description = "Maintenance page HTTP status code."
  default     = 503
}

variable "lb_ip_address_type" {
  description = "ipv4 or dualstack for ipv6 support"
  default     = "ipv4"
}

variable "lb_security_group_ids" {
  type    = list(string)
  default = []
}

variable "lb_cert_arn" {
  default = ""
}

variable "ecs_incoming_allowed_cidr" {
  description = "The CIDR to allow incoming traffic to the ECS tasks.  Overrides the default of the VPC"
  default     = ""
}

variable "datadog_api_key" {
  description = "Datadog API key. This will activate the Datadog agent sidecar/replica container. To accommodate additional load, please increase var.cpu to an additional 512 or more. Similarly, increase var.memory to an additional 1024."
  default     = ""
  type        = string
}

variable "datadog_agent_version" {
  description = "Datadog agent container version."
  default     = "latest"
  type        = string
}
