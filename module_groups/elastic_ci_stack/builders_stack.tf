module "builders_stack" {
  source = "../../modules/buildkite_elastic_stack"

  bootstrap_script_url = "${var.builder_bootstrap_script_url}"
  buildkite_agent_token = "${var.buildkite_agent_token}"
  instance_type = "c5.large"
  key_name = "${aws_key_pair.key_pair.key_name}"
  max_size = "1"
  min_size = "1"
  secrets_bucket = "${var.secrets_bucket}"
  stack_ami_version = "${var.stack_ami_version}"
  stack_name = "${var.buildkite_env_name}-builders"
  stack_template_url = "${var.stack_template_url}"
}
