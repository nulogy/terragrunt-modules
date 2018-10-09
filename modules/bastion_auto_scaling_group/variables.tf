variable "ecs_ami" {
  type = "string"
  description = "The AMI to use. Defaults to Amazon Linux AMI designed for ECS. Override me to use a newer AMI."
  default = "amzn-ami-2018.03.g-amazon-ecs-optimized"
}

variable "ecs_ami_owner" {
  type = "string"
  description = "The AWS account ID which provides the AMI we intend to use. Defaults to Amazon."
  default = "591542846629"
}

variable "ec2_subnet_ids" { type = "list" }
variable "lc_instance_type" { default = "" }
variable "environment_name" {}
variable "office_ip" { default = "" }
variable "public_key" {}
variable "skip" { default = "" }
variable "vpc_cidr" {}
variable "vpc_id" {}
