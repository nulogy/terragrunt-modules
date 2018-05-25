variable "name" {}
variable "count_cap_tag_prefix" {
  description = "Tag prefix for images that will be automatically capped at a certain limit"
  default = ""
}
variable "skip" { default = "" }
