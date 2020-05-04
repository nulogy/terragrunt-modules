variable "cert_domain" {
}

variable "desired_capacity" {
  default = ""
}

variable "ec2_public_key" {
}

variable "ecs_ami" {
  type        = string
  description = "The AMI to use. Defaults to Amazon Linux AMI designed for ECS. Override me to use a newer AMI."
  default     = "amzn-ami-2018.03.g-amazon-ecs-optimized"
}

variable "ecs_ami_owner" {
  type        = string
  description = "The AWS account ID which provides the AMI we intend to use. Defaults to Amazon."
  default     = "591542846629"
}

variable "environment_name" {
}

variable "lc_instance_type" {
}

variable "max_size" {
  default = ""
}

variable "min_size" {
  default = ""
}

variable "office_ip" {
}

variable "health_check_type" {
  default = "ELB"
}

variable "health_check_path" {
  default = "/"
}

variable "peer_account_id" {
  default = ""
}

variable "peer_vpc_id" {
  default = ""
}

variable "peer_vpc_cidr" {
  default = ""
}

variable "private_ecs_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "route53_domain" {
  default = ""
}

variable "route53_subdomain" {
  default = ""
}

variable "vpc_cidr" {
}
