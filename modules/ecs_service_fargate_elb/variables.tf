variable "cpu" {
  description = "CPU per Fargate container. Units are 1024 = 1 vCPU."
}

variable "command" {
  description = "Commands to execute after entrypoint"
  default = ["/bin/echo", "Start command not supplied, just exiting"]
  type = "list"
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

variable "kms_key_id" {
  description = "KMS Key to retrieve secrets with. Goes with param store namespace."
  default = ""
}
variable "log_group_name" {
  description = "The place to send Cloudwatch logs for the container's process. Base this on environment name."
}

variable "memory" {
  description = "Memory per Fargate container."
}

variable "param_store_namespace" {
  default = "Path for SSM secret parameters that the container needs permission to access."
}

variable "security_groups" {
  description = "Security groups for the container. Determines inbound and outbound connections / ports."
  type = "list"
}

variable "subnets" {
  description = "Determines the AZ for the containers. Usually put all subnets from the VPC."
  type = "list"
}

variable "service_name" {
  description = "Service name. Used for tagging."
}

variable "health_check" {
  description = "Commands to execute a container health check"
  default = ["CMD-SHELL", "echo OK || exit 1"]
  type = "list"
}
