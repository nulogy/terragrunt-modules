variable "database_address" {
  type = string
}

variable "postgres_version" {
  type    = string
  default = "latest"
}

variable "database_name" {
  type = string
}

variable "database_port" {
  type    = string
  default = "5432"
}

variable "data_platform_database_user__events_table" {
  type    = string
  default = "message_bus_subscription_events"
}

variable "data_platform_database_user__password" {
  type = string
}

variable "data_platform_database_user__username" {
  type    = string
  default = "data_platform_database_user"
}

variable "database_admin_username" {
  type = string
}

variable "database_admin_password" {
  type = string
}

variable "additional_commands" {
  type        = string
  description = "Additional SQL statements to execute when creating the user"
  default     = ""
}