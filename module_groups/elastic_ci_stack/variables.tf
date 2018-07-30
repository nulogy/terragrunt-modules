variable "builder_bootstrap_script_url" { default = "" }
variable "builder_agents_per_instance" { default = "1" }
variable "builder_instance_type" { default = "c5.large" }
variable "builder_max_size" { default = "1" }
variable "buildkite_agent_token" { }
variable "buildkite_env_name" { description = "Use to prefix resource names and buildkite queue names" }
variable "buildkite_queue_prefix" { description = "Use to prefix buildkite queue names" }
variable "runner_agents_per_instance" { default = 1 }
variable "runner_bootstrap_script_url" { default = "" }
variable "runner_instance_type" {}
variable "runner_max_size" {}
variable "runner_scale_adjustment" {}
variable "runner_spot_price" {}
variable "secrets_bucket" { }
variable "stack_ami_version" { default = "" }
variable "stack_template_url" { description = "URL pointing to the buildkite aws cloud formation template" }
