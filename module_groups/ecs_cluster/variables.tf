variable "cluster_name" {
  description = "Used for unique naming. Usually equal to `environment_name`-cluster."
}

variable "desired_capacity" {
  description = "Number of EC2 servers to launch. There are no scaling rules to go higher in response to traffic."
  default = ""
}

variable "max_size" {
  description = "Max EC2 servers to have running."
  default = ""
}

variable "min_size" {
  description = "Min EC2 servers to have running."
  default = ""
}

variable "ec2_public_key" {
  description = "Public key for this instance. The corresponding private key is usually shared with 1Pass."
}

variable "ecs_ami_version" {
  description = "AMI version to launch as an EC2 Instance and register with ECS."
  default = "2017.09.g"
}

variable "environment_name" {
  description = "Environment name. Used for tagging and naming the cluster."
}

variable "health_check_type" {
  description = "Health Check for the Autoscaling Group. 'EC2' or 'ELB'"
  default = "EC2"
}

variable "lc_instance_type" {
  description = "Instance type to launch. Eg. 't2.small'"
}

variable "private_subnet_ids" {
  description = "Subnets for the EC2 instances to be launched into."
  type = "list"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC. This is used for security group access to the EC2 instances. Eg. '172.17.0.0/16'."
}

variable "vpc_id" {
  description = "VPC Id. This is used for security groups for the EC2 instances."
}
