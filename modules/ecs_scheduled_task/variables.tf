variable "alert_topic_arn" {
}

variable "ecs_cluster_name" {
}

variable "ecs_task_arn" {
}

variable "environment_name" {
}

variable "event_target_json" {
}

variable "schedule_expression" {
}

variable "security_groups" {
  default = []
  type = list(string)
}

variable "skip" {
  default = ""
}

variable "subnets" {
  type = list(string)
}

variable "task_name" {
}

