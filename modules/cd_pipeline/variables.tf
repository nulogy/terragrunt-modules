variable "environment_name" {}
variable "skip" { default = false }
variable "terraform_state_bucket" {
  description = "Used to setup permission to Read/Write terraform state"
}
