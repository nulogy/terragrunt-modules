locals {
  scale_up_adjustment   = var.scale_adjustment > 0 ? var.scale_adjustment : var.scale_up_adjustment
  scale_down_adjustment = var.scale_adjustment > 0 ? var.scale_adjustment : var.scale_down_adjustment
}

resource "aws_security_group" "stack_security_group" {
  name_prefix = "${var.stack_name}-SecurityGroup-"

  vpc_id = var.vpc_id

  # Allow SSH connections from the VPN
  ingress {
    cidr_blocks = ["10.0.0.0/8"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  # Outbound connections are open
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
  }

  tags = {
    Name           = "${var.stack_name} security group"
    resource_group = var.stack_name
  }
}

resource "aws_cloudformation_stack" "stack" {
  name         = var.stack_name
  template_url = var.stack_template_url
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]

  parameters = {
    AgentsPerInstance                        = var.agents_per_instance
    AssociatePublicIpAddress                 = var.associate_public_ip_address
    BootstrapScriptUrl                       = var.bootstrap_script_url
    BuildkiteAgentToken                      = var.buildkite_agent_token
    BuildkiteAgentTimestampLines             = "true"
    BuildkiteQueue                           = var.buildkite_queue
    ECRAccessPolicy                          = "poweruser"
    EnableDockerUserNamespaceRemap           = "false"
    EnableExperimentalLambdaBasedAutoscaling = var.enable_experimental_lambda_based_autoscaling
    InstanceType                             = var.instance_type
    KeyName                                  = var.key_name
    ManagedPolicyARN                         = var.managed_policy_arn
    MaxSize                                  = var.max_size
    MinSize                                  = var.min_size
    RootVolumeSize                           = var.root_volume_size
    SecretsBucket                            = var.secrets_bucket
    SecurityGroupId                          = aws_security_group.stack_security_group.id
    ScaleDownAdjustment                      = "-${local.scale_down_adjustment}"
    ScaleDownPeriod                          = var.scale_down_period
    ScaleUpAdjustment                        = local.scale_up_adjustment
    SpotPrice                                = var.spot_price
    Subnets                                  = join(",", var.subnet_ids)
    VpcId                                    = var.vpc_id
  }

  lifecycle {
    ignore_changes = [parameters["BuildkiteAgentToken"]]
  }
}

