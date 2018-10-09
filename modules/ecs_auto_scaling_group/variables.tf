variable "desired_capacity" {}
variable "default_cooldown" { default = 300 }

variable "drain_lambda_sns_arn" {
  description = "SNS endpoint for a topic which drain-lambda can subscribe to to perform graceful server termination."
}

variable "ecs_ami" {
  type = "string"
  description = "The AMI to use. Defaults to Amazon Linux AMI designed for ECS. Override me to get a newer AMI."
  default = "amzn-ami-2018.03.g-amazon-ecs-optimized"
}

variable "ecs_ami_owner" {
  type = "string"
  description = "The AWS account ID which provides the AMI we intend to use. Defaults to Amazon."
  default = "591542846629"
}

variable "ecs_cluster_name" {}
variable "ec2_subnet_ids" { type = "list" }
variable "lc_instance_type" {}
variable "environment_name" {}
variable "max_size" {}
variable "min_size" {}
variable "health_check_type" {}
variable "public_key" {}
variable "vpc_cidr" {}
variable "vpc_id" {}
