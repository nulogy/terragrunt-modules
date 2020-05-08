variable "environment_name" {
}

variable "internet_gw_id" {
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "skip" {
  default = ""
}

variable "subnet_adjective" {
}

variable "vpc_id" {
}

variable "peer_vpc_cidr" {
  default = ""
}

variable "vpc_peering_connection_id" {
  default = ""
}

