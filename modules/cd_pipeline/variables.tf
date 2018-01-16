variable "environment_name" {}
variable "skip" { default = false }
variable "terraform_state_bucket" {
  description = "Used to setup permission to Read/Write terraform state"
}
variable "terraform_state_lock_dynamodb_table" {
  description = "Used to setup permission to Read/Write terraform state lock table"
}
