variable "app_fqdn" {
}

variable "app_origin_ssl_protocols" {
  type = list(string)
  default = ["TLSv1.2"]
}

variable "aws_profile" {
  default = ""
}

variable "cert_domain" {
}

variable "environment_name" {
}

variable "minimum_protocol_version" {
  type = string
  default = "TLSv1.2_2018"
}

variable "route53_domain" {
}

variable "route53_subdomain" {
  default = ""
}

variable "skip" {
  default = ""
}

variable "static_assets_path" {
}

