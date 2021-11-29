variable "environment_name" {
  description = "Environment name. Used for naming and tagging. This variable is derived from the path of the environment directory."
}

variable "environment_key" {
  description = "This has to be less than 20 characters in order to be a key for a LaunchDarkly environment."
}

variable "environment_tags" {
  type        = list(string)
  description = "The tags to set in the environment in LaunchDarkly."
  default     = []
}

variable "production_environment" {
  type        = bool
  description = "Is used to set the color of the environment and any associated tags for production or test environments"
  default     = false
}

variable "project_key" {
  description = "The LaunchDarkly project key to lookup environments on"
}

variable "use_shared_environment" {
  description = "Signals whether to create a new LaunchDarkly environment or use an existing one. Used primarily in disaster recovery scenarios to get the same feature flag configurations from the original environment."
  type        = bool
  default     = false
}
