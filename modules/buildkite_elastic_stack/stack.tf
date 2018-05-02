data "aws_ami" "buildkite_ami" {
  count = "${length(var.stack_ami_version) > 0 ? 1 : 0}"

  filter {
    name = "name"
    values = ["buildkite-stack-${var.stack_ami_version}-*"]
  }

  owners = ["172840064832"]
  most_recent = true
}

resource "aws_cloudformation_stack" "stack" {
  name = "${var.stack_name}"
  template_url = "${var.stack_template_url}"
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]

  parameters {
    AgentsPerInstance = "${var.agents_per_instance}"
    BootstrapScriptUrl = "${var.bootstrap_script_url}"
    BuildkiteAgentToken = "${var.buildkite_agent_token}"
    BuildkiteQueue = "${var.stack_name}"
    ECRAccessPolicy = "poweruser"
    # https://github.com/hashicorp/terraform/issues/16726
    ImageId = "${element(concat(data.aws_ami.buildkite_ami.*.id, list("")), 0)}"
    InstanceType = "${var.instance_type}"
    KeyName = "${var.key_name}"
    MaxSize = "${var.max_size}"
    MinSize = "${var.min_size}"
    SecretsBucket = "${var.secrets_bucket}"
    ScaleDownAdjustment = "-${var.scale_adjustment}"
    ScaleDownPeriod = "3600"
    ScaleUpAdjustment = "${var.scale_adjustment}"
    SpotPrice = "${var.spot_price}"
  }

  lifecycle {
    ignore_changes = ["parameters.BuildkiteAgentToken"]
  }
}
