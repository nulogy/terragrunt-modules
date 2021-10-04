variable "additional_commands" {
  type        = string
  description = "Additional SQL statements to execute when creating the user"
  default     = ""
}

variable "database_address" {
  type = string
}

variable "database_admin_username" {
  type = string
}

variable "database_admin_password" {
  type = string
}

variable "database_name" {
  type = string
}

variable "database_port" {
  type    = string
  default = "5432"
}

variable "data_platform_database_user__password" {
  type = string
}

variable "data_platform_database_user__username" {
  type    = string
  default = "data_platform"
}

variable "postgres_version" {
  type    = string
  default = "latest"
}