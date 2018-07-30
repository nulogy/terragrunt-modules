variable "certificate_domain" {
  description = "The domain of the certificate used by the ELB for TLS termination. Eg. nulogy.net"
}

variable "environment_name" {
  description = "Used for tagging, and naming."
}

variable "public_subnet_ids" {
  description = "Public subnets for RabbitMQ Load Balancers. Defines the range of public IPs that the ELB can take."
  type = "list"
}

variable "vpc_id" {
  description = "Determines where the RabbitMQ servers live."
}
