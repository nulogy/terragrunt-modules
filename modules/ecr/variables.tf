variable "name" {
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE"
  default     = "MUTABLE"
}

variable "skip" {
  default = ""
}

variable "image_lifecycle_count" {
  description = "How many images should be retained in the ECR repo?"
  default = "100"
}

