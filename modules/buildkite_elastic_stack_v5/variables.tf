variable "agents_per_instance" {
  default = 1
}

variable "associate_public_ip_address" {
  default = true
}

variable "bootstrap_script_url" {
  default = ""
}

variable "buildkite_agent_token" {
}

variable "buildkite_queue" {
}

variable "instance_type" {
}

variable "key_name" {
}

variable "managed_policy_arn" {
  default = ""
}

variable "max_size" {
}

variable "min_size" {
  default = 0
}

variable "root_volume_size" {
  description = "Size of each instance's root EBS volume (in GB)"
  default     = 250
}

variable "scale_in_idle_period" {
  description = "Number of seconds an agent must be idle before terminating"
  default     = 3600
}

variable "scale_out_factor" {
  description = "A decimal factor to apply to scale out changes to speed up or slow down scale-out"
  default     = 1.0
}

variable "secrets_bucket" {
}

variable "spot_price" {
  default = 0
}

variable "stack_name" {
}

variable "stack_template_url" {
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
}
