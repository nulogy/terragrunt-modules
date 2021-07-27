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
    AgentsPerInstance              = var.agents_per_instance
    AssociatePublicIpAddress       = var.associate_public_ip_address
    BootstrapScriptUrl             = var.bootstrap_script_url
    BuildkiteAgentToken            = var.buildkite_agent_token
    BuildkiteAgentTimestampLines   = "true"
    BuildkiteQueue                 = var.buildkite_queue
    ECRAccessPolicy                = "poweruser"
    EnableDockerUserNamespaceRemap = "false"
    InstanceType                   = var.instance_type
    KeyName                        = var.key_name
    ManagedPolicyARN               = var.managed_policy_arn
    MaxSize                        = var.max_size
    MinSize                        = var.min_size
    RootVolumeSize                 = var.root_volume_size
    SecretsBucket                  = var.secrets_bucket
    SecurityGroupId                = aws_security_group.stack_security_group.id
    ScaleInIdlePeriod              = var.scale_in_idle_period
    ScaleOutFactor                 = var.scale_out_factor
    SpotPrice                      = var.spot_price
    Subnets                        = join(",", var.subnet_ids)
    VpcId                          = var.vpc_id
  }

  lifecycle {
    ignore_changes = [parameters["BuildkiteAgentToken"]]
  }
}

resource "aws_iam_policy" "deploy_policy" {
  name   = "${var.environment_name}-terraform-deploy-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "acm:*",
        "autoscaling:*",
        "application-autoscaling:*",
        "cloudformation:*",
        "cloudfront:*",
        "cloudwatch:*",
        "codedeploy:*",
        "dynamodb:*",
        "ec2:*",
        "ecr:*",
        "ecs:*",
        "elasticache:*",
        "elasticloadbalancing:*",
        "events:*",
        "iam:*",
        "kms:*",
        "lambda:*",
        "logs:*",
        "rds:*",
        "route53:*",
        "ssm:*",
        "s3:*",
        "sns:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "deploy_policy_attachment" {
  policy_arn = aws_iam_policy.deploy_policy.arn
  role       = module.buildkite_deployers.instance_role_name
}

