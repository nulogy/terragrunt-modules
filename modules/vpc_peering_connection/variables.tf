variable "auto_accept" { default = false }
variable "environment_name" {}
variable "peer_account_id" {}
variable "peer_vpc_cidr" {}
variable "peer_vpc_id" {}
variable "routing_tables" { type = "list", default = [] }
variable "skip" { default = "" }
variable "vpc_id" {}
