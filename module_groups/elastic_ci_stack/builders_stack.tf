module "builders_stack" {
  source = "/deployer/modules/buildkite_elastic_stack"

  agents_per_instance = "${var.builder_agents_per_instance}"
  bootstrap_script_url = "${var.builder_bootstrap_script_url}"
  buildkite_agent_token = "${var.buildkite_agent_token}"
  buildkite_queue = "${var.buildkite_queue_prefix}-builders"
  instance_type = "${var.builder_instance_type}"
  key_name = "${aws_key_pair.key_pair.key_name}"
  max_size = "${var.builder_max_size}"
  min_size = "${var.builder_min_size}"
  root_volume_size = "${var.builder_root_volume_size}"
  scale_down_adjustment = "${var.builder_scale_down_adjustment}"
  scale_up_adjustment = "${var.builder_scale_up_adjustment}"
  secrets_bucket = "${var.secrets_bucket}"
  stack_ami_version = "${var.stack_ami_version}"
  stack_name = "${var.buildkite_env_name}-builders"
  stack_template_url = "${var.stack_template_url}"
}
