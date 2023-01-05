variable "environment_name" {
  description = "Environment name. Used for tagging."
}

variable "description" {
  default = "Multi-Region key"
}

variable "administrator_role" {
  description = "Administrator role provisioned by AWS SSO"
}

variable "developer_role" {
  description = "Developer role provisioned by AWS SSO"
}
