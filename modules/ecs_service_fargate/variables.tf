variable "cpu" {
  description = "CPU per Fargate container. Units are 1024 = 1 vCPU."
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

variable "service_name" {
  description = "Service name. Used for tagging."
}

variable "kms_key_id" {
  description = "KMS Key to retrieve secrets with. Goes with param store namespace."
}

variable "log_group_name" {
  description = "The place to send Cloudwatch logs for the container's process. Base this on environment name."
}

variable "memory" {
  description = "Memory per Fargate container."
}

variable "param_store_namespace" {
  description = "Path for SSM secret parameters that the container needs permission to access."
}

variable "security_groups" {
  description = "Security groups for the container. Determines inbound and outbound connections / ports."
  type        = list(string)
}

variable "subnets" {
  description = "Determines the AZ for the containers. Usually put all subnets from the VPC."
  type        = list(string)
}

variable "command" {
  description = "Commands to execute after entrypoint"
  default     = ["/bin/echo", "Start command not supplied, just exiting"]
  type        = list(string)
}

variable "health_check" {
  description = "Commands to execute a container health check"
  default     = ["CMD-SHELL", "echo OK || exit 1"]
  type        = list(string)
}

variable "task_definition_json" {
  description = "allows specifying a different JSON task definition, if none default (1 container per task) will be used"
  default     = ""
  type        = string
}

variable "containers_per_task" {
  description = "Number of container to run per task. Used to specify the amount of memory for each container if running multiple per task."
  default     = 1
}
