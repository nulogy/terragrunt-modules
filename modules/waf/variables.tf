variable "environment_name" {
  description = "Environment name. Used for naming and tagging."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "country_codes_allow_list" {
  description = "ISO 3166-2 country codes that are expected to receive legitimate traffic and won't be labelled by geo matching. Any traffic originating from a country not listed will be labelled an can be further ruled out by country and/or region blocking."
  type        = list(string)
  default     = ["CA", "US"]
}

variable "country_codes_block_list" {
  description = "ISO 3166-2 country codes that should be blocked."
  type        = list(string)
  default     = []
}

variable "region_codes_block_list" {
  description = "ISO 3166-2 region codes that should be blocked. For a list of regions for Canada, see https://en.wikipedia.org/wiki/ISO_3166-2:CA"
  type        = list(string)
  default     = []
}

variable "enable_block" {
  description = "Enable block of countries and/or regions listed. If set to false, it will use count mode instead of block."
  type        = bool
  default     = false
}
