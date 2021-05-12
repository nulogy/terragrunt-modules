variable "aws_region" {
}
variable "aws_profile" {
}

variable "environment_name" {
}

variable "environment_short_name" {
}

variable "logzio__api_url" {
  default = "https://listener.logz.io:8071"
}

variable "logzio__logs_format" {
  default = "JSON"
}

variable "logzio__logs_type" {
  default = "cloudwatch"
}

variable "logzio__module_name" {
  description = "The module which wants to integrate its logs from cloudwatch to logzio. (e.g.: resque_scheduler)"
}

variable "logzio__log_group_name" {
}

variable "logzio__log_group_arn" {
}

variable "logzio__api_key" {}
