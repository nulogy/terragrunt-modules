variable "aws_profile" {
  description = "The AWS account you want to use, as defined by your ~/.aws/credentials file."
}

variable "aws_account_id" {
  description = "AWS account ID"
}

variable "admin_sso_role_id" {
  description = "SRE/admin SSO role ID"
}

variable "developer_sso_role_id" {
  description = "Team developer SSO role ID"
}

