resource "aws_cloudformation_stack" "stack" {
  name = "${var.stack_name}"
  template_url = "${var.stack_template_url}"
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]

  parameters {
    AgentsPerInstance = "1"
    BuildkiteAgentToken = "${var.buildkite_agent_token}"
    BuildkiteQueue = "${var.stack_name}"
    ECRAccessPolicy = "poweruser"
    ImageId = ""
    InstanceType = "${var.instance_type}"
    KeyName = "${var.key_name}"
    MaxSize = "${var.max_size}"
    MinSize = "${var.min_size}"
    ScaleDownAdjustment = "-${var.scale_adjustment}"
    ScaleDownPeriod = "3600"
    ScaleUpAdjustment = "${var.scale_adjustment}"
    SpotPrice = "${var.spot_price}"
  }

  lifecycle {
    ignore_changes = ["parameters.BuildkiteAgentToken"]
  }
}

resource "aws_s3_bucket_object" "stack_global_env" {
  bucket = "${aws_cloudformation_stack.stack.outputs["ManagedSecretsBucket"]}"
  key    = "/env"
  source = "${var.stack_config_env}"
  server_side_encryption = "aws:kms"
}
