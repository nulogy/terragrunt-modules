variable "environment_name" {
  description = "Environment name. Used for naming and tagging."
  type        = string
}

variable "maintenance_mode" {
  description = "Show a maintenance page."
  type        = bool
  default     = false
}

variable "aliases" {
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution."
  type        = list(string)
  default     = null
}

variable "custom_error_response" {
  description = "A list of custom error response elements."
  type        = any
  default     = []
}

variable "origin" {
  description = "One or more origins for this distribution (multiples allowed)."
  type        = any
  default     = []
}

variable "default_root_object" {
  description = "Object that you want CloudFront to return (for example, index.html) when an end user requests the root URL."
  default     = null
}

variable "default_cache_behavior" {
  description = "The default cache behaviors resource for this distribution."
  type        = any
  default     = {}
}

variable "ordered_cache_behavior" {
  description = "An ordered list of cache behaviors resource for this distribution. List from top to bottom in order of precedence. The topmost cache behavior will have precedence 0."
  type        = any
  default     = []
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "viewer_certificate" {
  description = "The SSL configuration for this distribution"
  type        = any
  default     = {}
}

variable "web_acl_id" {
  description = "If you're using AWS WAF to filter CloudFront requests, the Id of the AWS WAF web ACL that is associated with the distribution. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned. If using WAFv2, provide the ARN of the web ACL."
  type        = string
  default     = null
}