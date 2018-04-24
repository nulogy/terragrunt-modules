variable "buildkite_agent_token" { }
variable "buildkite_env_name" { description = "Use to prefix resource names and buildkite queue names" }
variable "runner_instance_type" {}
variable "runner_max_size" {}
variable "runner_scale_adjustment" {}
variable "runner_spot_price" {}
variable "stack_ami_version" { default = "" }
variable "stack_config_env" { description = "Environment file for all buildkite pipelines" }
variable "stack_template_url" { description = "URL pointing to the buildkite aws cloud formation template" }
