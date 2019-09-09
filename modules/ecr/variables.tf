variable "name" {
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE"
  default = "MUTABLE"
}

variable "skip" {
  default = ""
}

