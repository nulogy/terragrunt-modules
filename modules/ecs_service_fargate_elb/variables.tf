variable "cpu" {
  description = "CPU per Fargate task. Units are 1024 = 1 vCPU."
  type        = number
}

variable "command" {
  description = "Commands to execute after entrypoint"
  default     = ["/bin/echo", "Start command not supplied, just exiting"]
  type        = list(string)
}

variable "container_port" {
  description = "The port that is exposed by the container"
}

variable "desired_count" {
  description = "How many Fargate containers to run initially."
}

variable "docker_image_name" {
  description = "Which docker container to run. e.g. 501253995157.dkr.ecr.us-east-1.amazonaws.com/packmanager-qa-dev:0.1.2"
}

variable "ecs_cluster_name" {
  description = "The name of the cluster to run this service in."
}

variable "envars" {
  description = "JSON format environment variables to pass into the container task."
}

variable "environment_name" {
  description = "Environment name. Used for tagging."
}

variable "health_check_command" {
  description = "A test to perform to check that the container is healthy."
  type        = list(string)
  default     = []
}

variable "kms_key_id" {
  description = "KMS Key to retrieve secrets with. Goes with param store namespace."
}

variable "log_group_name" {
  description = "The place to send Cloudwatch logs for the container's process. Base this on environment name."
}

variable "vpc_cidr" {
  description = "The VPC IP range. Used for ingress rules."
}

variable "vpc_id" {
  description = "The VPC that this task should live in."
}

variable "memory" {
  description = "Memory per Fargate task."
  type        = number
}

variable "param_store_namespace" {
  default = "Path for SSM secret parameters that the container needs permission to access."
}

variable "subnets" {
  description = "Determines the AZ for the containers. Usually put all subnets from the VPC."
  type        = list(string)
}

variable "security_group_name" {
  description = "Manually set the security group name. This exists as a bridge to work around a value that was unfortunately hardcoded in versions <= 5.0.0. When writing new code, you can probably ignore this and use the default blank string."
  default     = ""
}

variable "service_name" {
  description = "Service name. Used for tagging."
}

variable "target_group_arn" {
  description = "Target of an Amazon ALB (Load Balancer), as given by a load balancer."
}

variable "datadog_enabled" {
  description = "This option will activate the Datadog agent sidecar/replica container on the same ECS task. Please adjust var.cpu and/or var.memory to accommodate if necessary."
  default     = false
  type        = bool
}

variable "datadog_agent_version" {
  description = "Datadog agent container version."
  default     = "latest"
  type        = string
}

variable "datadog_env" {
  description = "Datadog environment (DD_ENV)."
  default     = "development"
  type        = string
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  default     = ""
}
