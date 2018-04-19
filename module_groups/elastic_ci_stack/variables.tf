variable "buildkite_agent_token" { }
variable "buildkite_api_access_token" {}
variable "buildkite_env_name" { description = "Use to prefix resource names and buildkite queue names" }
variable "stack_template_url" { description = "URL pointing to the buildkite aws cloud formation template" }
variable "stack_config_env" { description = "Environment file for all buildkite pipelines" }
