resource "aws_cloudformation_stack" "stack" {
  name = "${var.stack_name}"
  template_url = "${var.stack_template_url}"
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]

  parameters {
    AgentsPerInstance = "1"
    BuildkiteAgentToken = "${var.buildkite_agent_token}"
    BuildkiteApiAccessToken = "${var.buildkite_api_access_token}"
    BuildkiteOrgSlug = "nulogy-corp"
    BuildkiteQueue = "${var.stack_name}"
    ECRAccessPolicy = "poweruser"
    ImageId = ""
    InstanceType = "c5.large"
    KeyName = "${var.key_name}"
    MaxSize = "64"
    ScaleDownAdjustment = "-32"
    ScaleDownPeriod = "3600"
    ScaleUpAdjustment = "32"
    SpotPrice = "0.085"
  }

  lifecycle {
    ignore_changes = ["parameters.BuildkiteAgentToken", "parameters.BuildkiteApiAccessToken"]
  }
}

resource "aws_s3_bucket_object" "stack_global_env" {
  bucket = "${aws_cloudformation_stack.stack.outputs["ManagedSecretsBucket"]}"
  key    = "/env"
  source = "${var.stack_config_env}"
  server_side_encryption = "aws:kms"
}
