variable "cluster_name" {
  description = "Used for unique naming. Usually equal to `environment_name`-cluster."
}

variable "desired_capacity" {
  description = "Number of EC2 servers to launch. There are no scaling rules to go higher in response to traffic."
  default     = ""
}

variable "max_size" {
  description = "Max EC2 servers to have running."
  default     = ""
}

variable "min_size" {
  description = "Min EC2 servers to have running."
  default     = ""
}

variable "ec2_public_key" {
  description = "Public key for this instance. The corresponding private key is usually shared with 1Pass."
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
  description = "Environment name. Used for tagging and naming the cluster."
}

variable "health_check_type" {
  description = "Health Check for the Autoscaling Group. 'EC2' or 'ELB'"
  default     = "EC2"
}

variable "lc_instance_type" {
  description = "Instance type to launch. Eg. 't2.small'"
}

variable "private_subnet_ids" {
  description = "Subnets for the EC2 instances to be launched into."
  type        = list(string)
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC. This is used for security group access to the EC2 instances. Eg. '172.17.0.0/16'."
}

variable "vpc_id" {
  description = "VPC Id. This is used for security groups for the EC2 instances."
}

variable "sg_ingress_cidr" {
  default = "127.0.0.0/8"
}

variable "sg_ingress_from_port" {
  default = "65535"
}

variable "sg_ingress_to_port" {
  default = "65535"
}

variable "sg_ingress_protocol" {
  default = "udp"
}

