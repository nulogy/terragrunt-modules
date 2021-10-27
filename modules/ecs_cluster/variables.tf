variable "name" {
}

variable "container_insights" {
  // More info: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/cloudwatch-container-insights.html
  description = "Enable Cloudwatch Container Insights for this cluster, which includes CPU, Memory, etc for tasks."
  default     = false
}

variable "vpc_id" {
}