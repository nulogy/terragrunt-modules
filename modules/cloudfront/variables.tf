variable "assets_bucket_domain" {
}

variable "aws_profile" {
  default = ""
}

variable "cert_domain" {
}

variable "environment_name" {
}

variable "app_fqdn" {
}

variable "app_origin_ssl_protocols" {
  type = list(string)
}

variable "minimum_protocol_version" {
  type = string
}

variable "route53_domain" {
}

variable "route53_subdomain" {
  default = ""
}

variable "static_assets_path" {
}

variable "skip" {
  default = ""
}

