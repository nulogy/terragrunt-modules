module "runners_stack" {
  source = "../../modules/buildkite_elastic_stack"

  buildkite_agent_token = "${var.buildkite_agent_token}"
  buildkite_api_access_token = "${var.buildkite_api_access_token}"
  key_name = "${aws_key_pair.key_pair.key_name}"
  stack_config_env = "${var.stack_config_env}"
  stack_name = "${var.buildkite_env_name}-runners"
  stack_template_url = "${var.stack_template_url}"
}
