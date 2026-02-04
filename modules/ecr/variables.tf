variable "name" {
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE"
  default     = "IMMUTABLE"
}

variable "skip" {
  default = ""
}

variable "image_lifecycle_count" {
  description = "How many images should be retained in the ECR repo?"
  default     = "100"
}

variable "enable_default_lifecycle_policy" {
  type        = bool
  description = "It enable/disable the lifecycle_policy resources included by default in this module"
  default     = true
}
