locals {
  builder_stack_name = "${var.buildkite_env_name}-builders"
}

resource "aws_cloudformation_stack" "builders" {
  name = "${local.builder_stack_name}"
  template_url = "${var.stack_template_url}"
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]

  parameters {
    AgentsPerInstance = "1"
    BuildkiteAgentToken = "${var.buildkite_agent_token}"
    BuildkiteApiAccessToken = "${var.buildkite_api_access_token}"
    BuildkiteOrgSlug = "nulogy-corp"
    BuildkiteQueue = "${local.builder_stack_name}"
    ECRAccessPolicy = "poweruser"
    ImageId = ""
    InstanceType = "c5.large"
    KeyName = "${aws_key_pair.key_pair.key_name}"
    MaxSize = "1"
    MinSize = "1"
  }

  lifecycle {
    ignore_changes = ["parameters.BuildkiteAgentToken", "parameters.BuildkiteApiAccessToken"]
  }
}

resource "aws_s3_bucket_object" "builders_global_env" {
  bucket = "${aws_cloudformation_stack.builders.outputs["ManagedSecretsBucket"]}"
  key    = "/env"
  source = "${var.stack_config_env}"
  server_side_encryption = "aws:kms"
}
