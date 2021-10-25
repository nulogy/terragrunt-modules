variable "agents_per_instance" {
  description = "Number of Buildkite agents to run on each instance."
  default     = 1
}

variable "associate_public_ip_address" {
  description = "Associate instances with public IP addresses. Disabled to not expose instances to the internet unintentionally."
  default     = false
}

variable "bootstrap_script_url" {
  description = "URL containing a script to run on each instance during boot."
  default     = ""
}

variable "buildkite_agent_token" {
  description = "Buildkite agent registration token. This token will be stored in parameter store. If you don't know your agent token, there is a Reveal Agent Token button available on the right-hand side of the [Agents page](https://buildkite.com/organizations/-/agents)."
  sensitive   = true
}

variable "buildkite_queue" {
  description = "Queue name that agents will use, targeted in pipeline steps using queue={value}."
}

variable "instance_type" {
  description = "Instance type. Comma-separated list with 1-4 instance types. The order is a prioritized preference for launching OnDemand instances, and a non-prioritized list of types to consider for Spot Instances (where used)."
}

variable "key_name" {
  description = "SSH keypair used to access the buildkite instances via ec2_user, setting this will enable SSH ingress."
  default     = ""
}

variable "kms_key" {
  description = "AWS KMS key ID used to encrypt the parameter agent token in parameter store."
}

variable "managed_policy_arn" {
  description = "Comma separated list of managed IAM policy ARNs to attach to the instance role."
  default     = ""
}

variable "max_size" {
  description = "Maximum number of instances."
  default     = 10
}

variable "min_size" {
  description = "Minimum number of instances."
  default     = 0
}

variable "root_volume_size" {
  description = "Size of each instance's root EBS volume (in GB)."
  default     = 250
}

variable "scale_in_idle_period" {
  description = "Number of seconds an agent must be idle before terminating."
  default     = 3600
}

variable "scale_out_factor" {
  description = "A decimal factor to apply to scale out changes to speed up or slow down scale-out."
  default     = 1.0
}

variable "secrets_bucket" {
  description = "Name of an existing S3 bucket containing pipeline secrets (Created if left blank). See https://buildkite.com/docs/agent/v3/elastic-ci-aws#build-secrets for possible objects."
  default     = ""
}

variable "spot_price" {
  description = "Maximum spot price to use for the instances, in instance cost per hour. Values >0 will result in 100% of instances being spot. 0 means only use normal (non-spot) instances. This parameter is deprecated - we recommend setting to 0 and using OnDemandPercentage to opt into spot instances."
  default     = 0
}

variable "stack_name" {
  description = "Name used to tag resources."
  default     = "buildkite"
}

variable "stack_template_url" {
  description = "Stack template URL. See https://github.com/buildkite/elastic-ci-stack-for-aws/releases for options."
  default     = "https://s3.amazonaws.com/buildkite-aws-stack/v5.7.1/aws-stack.yml"
}

variable "subnet_ids" {
  description = "List of two existing VPC subnet ids where EC2 instances will run."
}

variable "vpc_id" {
  description = "Id of an existing VPC to launch instances into."
}
