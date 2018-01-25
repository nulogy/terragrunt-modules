resource "aws_iam_role" "monitoring" {
  name = "${var.environment_name}-db-monitoring-role"
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "rds.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole
resource "aws_iam_policy" "monitoring" {
  name = "${var.environment_name}-db-monitoring-policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:PutRetentionPolicy"
            ],
            "Resource": [
                "arn:aws:logs:*:*:log-group:RDS*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams",
                "logs:GetLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:*:*:log-group:RDS*:log-stream:*"
            ]
        }
    ]
}
EOF
}

# Workaround for InvalidParameterValue: IAM role ARN value is invalid or does not include the required permissions for: ENHANCED_MONITORING
# https://github.com/hashicorp/terraform/issues/5455
resource "aws_iam_role_policy_attachment" "monitoring" {
  role       = "${aws_iam_role.monitoring.name}"
  policy_arn = "${aws_iam_policy.monitoring.arn}"
}
