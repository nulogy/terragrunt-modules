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
  type = "list"
}

variable "container_port" {
  description = "Set the container port for access to the container via the ELB. This should match the port that the web server listens to."
  default = 3000
}

variable "desired_count" {
  description = "How many docker containers to run. Should be 2+"
  default = 2
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

variable "kms_key_id" {}

variable "memory" {}

variable "param_store_namespace" {}

variable "public_subnets" {
  type = "list"
}

variable "private_subnets" {
  type = "list"
}

variable "security_group_name" {
  description = "Manually set the security group name. This exists as a bridge to work around a value that was unfortunately hardcoded in versions <= 5.0.0. When writing new code, you can probably ignore this and use the default blank string."
  default = ""
}

variable "service_name" {}

variable "slow_start" {
  description = "Number of seconds to bleed traffic to the app. Useful for slow Rails startup time apps (like Packmanager)."
  default = 0
}

variable "stickiness_enabled" {
  description = "Boolean to turn on stickiness for the ALB Target Group. Turn on to allow CSS/JS to go to the same server as the request."
  default = false
}

variable "vpc_cidr" {}

variable "vpc_id" {}
