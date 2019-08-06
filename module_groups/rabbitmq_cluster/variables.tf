variable "aws_region" {
}

variable "allowed_ssh_cidr_block" {
  description = "Where SSH access is allowed from, in CIDR block format. For example, 172.17.158.146/32 to allow access to one IP"
  type        = string
}

variable "certificate_domain" {
  description = "The domain of the certificate used by the ELB for TLS termination. Eg. nulogy.net"
}

variable "count" {
  description = "Number of RabbitMQ servers."
  default     = 3
}

variable "domain" {
  description = "The domain for accessing RabbitMQ. Eg. cn-test.nulogy.com"
}

variable "environment_name" {
  description = "Used for tagging, and naming."
}

variable "instance_type" {
  description = "Size of the RabbitMQ instances in AWS. Larger on production."
  default     = "t2.small"
}

variable "kms_key_id" {
  description = "The KMS key used to store secrets which are injected into the server at runtime."
}

variable "private_subnet_ids" {
  description = "Subnets for RabbitMQ servers. Defines the range of private IPs that servers can take."
  type        = list(string)
}

variable "public_key" {
  description = "The public key for SSH access to the RabbitMQ servers. Share the private keys in 1Password."
}

variable "public_subnet_ids" {
  description = "Public subnets for RabbitMQ Load Balancers. Defines the range of public IPs that the ELB can take."
  type        = list(string)
}

variable "subdomain" {
  description = "The subdomain for accessing RabbitMQ. Eg. rabbitmq-qa"
}

variable "vpc_id" {
  description = "Determines where the RabbitMQ servers live."
}

