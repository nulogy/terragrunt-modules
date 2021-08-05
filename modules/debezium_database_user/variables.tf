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

variable "debezium_events_table" {
  type    = string
  default = "message_bus_subscription_events"
}

variable "debezium_password" {
  type = string
}

variable "debezium_username" {
  type    = string
  default = "debezium"
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
