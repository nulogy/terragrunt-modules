variable "environment_name" {
  type        = string
}

variable "api_key" {
  description = "Datadog API key. See https://app.datadoghq.com/account/settings#api."
  type        = string
}

variable "app_key" {
  description = "Datadog App key. See https://app.datadoghq.com/account/settings#api."
  type        = string
}

variable "param_store_namespace" {
  description = "Optional parameter store namespace. Default is <environment_name>"
  default     = ""
  type        = string
}

variable "dd_env" {
  description = "DD_ENV is used to distinguish production resources in Datadog. Possible values: development or production."
  default     = "development"
  type        = string
}

variable "pagerduty_service" {
  description = "PagerDuty service to notify for monitor alerting. Configuration: https://app.datadoghq.com/account/settings#integrations/pagerduty. Service directory: https://nu-infra.pagerduty.com/service-directory."
  default     = ""
  type        = string
}

