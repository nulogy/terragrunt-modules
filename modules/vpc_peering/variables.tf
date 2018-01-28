variable "environment_name" {}
variable "peer_vpc_id" {}
variable "peer_vpc_cidr" {}
variable "peer_vpc_subnets" {
  type = "list"
  default = []
}
variable "skip" { default = "" }
variable "vpc_id" {}
