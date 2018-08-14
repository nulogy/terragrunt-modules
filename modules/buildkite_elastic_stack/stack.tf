locals {
  office_ip = "${length(var.office_ip) > 0 ? var.office_ip : "64.215.160.242"}"
  scale_up_adjustment = "${var.scale_adjustment > 0 ? var.scale_adjustment : var.scale_up_adjustment}"
  scale_down_adjustment = "${var.scale_adjustment > 0 ? var.scale_adjustment : var.scale_down_adjustment}"
}

data "aws_ami" "buildkite_ami" {
  count = "${length(var.stack_ami_version) > 0 ? 1 : 0}"

  filter {
    name = "name"
    values = ["buildkite-stack-${var.stack_ami_version}-*"]
  }

  owners = ["172840064832"]
  most_recent = true
}

module "vpc" {
  source = "../vpc"
  environment_name = "${var.stack_name}"
  vpc_cidr = "10.0.0.0/16"
}

module "public_subnets" {
  source = "/deployer/modules/public_private_subnets"
  environment_name = "buildkite-runner-spotfleet"
  internet_gw_id = "${module.vpc.internet_gw_id}"
  public_subnets = ["10.0.21.0/24", "10.0.22.0/24", "10.0.23.0/24"]
  private_subnets = []
  subnet_adjective = "spotfleet"
  vpc_id = "${module.vpc.vpc_id}"
}

resource "aws_security_group" "stack_security_group" {
  name_prefix = "${var.stack_name}-SecurityGroup-"

  vpc_id = "${module.vpc.vpc_id}"

  # Allow SSH connections from the office
  ingress {
    cidr_blocks = ["${local.office_ip}/32"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

  # Outbound connections are open
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 65535
    protocol = "tcp"
  }

  tags {
    Name = "${var.stack_name} security group"
    resource_group = "${var.stack_name}"
  }
}

resource "aws_cloudformation_stack" "stack" {
  name = "${var.stack_name}"
  template_url = "${var.stack_template_url}"
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]

  parameters {
    AgentsPerInstance = "${var.agents_per_instance}"
    BootstrapScriptUrl = "${var.bootstrap_script_url}"
    BuildkiteAgentToken = "${var.buildkite_agent_token}"
    BuildkiteQueue = "${var.buildkite_queue}"
    ECRAccessPolicy = "poweruser"
    EnableDockerUserNamespaceRemap = "false"
    # https://github.com/hashicorp/terraform/issues/16726
    ImageId = "${element(concat(data.aws_ami.buildkite_ami.*.id, list("")), 0)}"
    InstanceType = "${var.instance_type}"
    KeyName = "${var.key_name}"
    ManagedPolicyARN = "${var.managed_policy_arn}"
    MaxSize = "${var.max_size}"
    MinSize = "${var.min_size}"
    SecretsBucket = "${var.secrets_bucket}"
    SecurityGroupId = "${aws_security_group.stack_security_group.id}"
    ScaleDownAdjustment = "-${local.scale_down_adjustment}"
    ScaleDownPeriod = "3600"
    ScaleUpAdjustment = "${local.scale_up_adjustment}"
    SpotPrice = "${var.spot_price}"
    Subnets = "${join(",", module.public_subnets.public_subnet_ids)}"
    VpcId = "${module.vpc.vpc_id}"
  }

  lifecycle {
    ignore_changes = ["parameters.BuildkiteAgentToken"]
  }
}
