data "aws_ami" "ecs_ami" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  filter {
    name = "name"
    values = ["amzn-ami-${var.ecs_ami_version}-amazon-ecs-optimized"]
  }

  owners = ["591542846629"]
}

data "aws_region" "current" {}

data "template_cloudinit_config" "user_data" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-boothook"
    content      = <<EOF
      #!/bin/bash
      # Re-create the docker0 bridge and setup a different CIDR so it does not conflict with legacy VPCs
      DOCKER_INTERFACE_CIDR="192.168.100.1/24"

      cloud-init-per once docker_options \
        echo "OPTIONS=\"\$OPTIONS --bip=$DOCKER_INTERFACE_CIDR\"" | sudo tee -a /etc/sysconfig/docker
    EOF

  }

  part {
    content_type = "text/x-shellscript"

    content = <<EOF
      #!/bin/bash
      echo 'Creating ECS_CLUSTER' > /tmp/user_data.log

      echo ECS_CLUSTER=${var.ecs_cluster_name} >> /etc/ecs/ecs.config
      echo ECS_RESERVED_MEMORY=256 >> /etc/ecs/ecs.config
      echo ECS_ENABLE_CONTAINER_METADATA=true >> /etc/ecs/ecs.config
      echo ECS_HOST_DATA_DIR=/var/lib/ecs >> /etc/ecs/ecs.config
    EOF
  }

  part {
    content_type = "text/x-shellscript"

    content = <<EOF
      #!/bin/bash

      # TODO Move me to the AMI for immutability purposes
      yum install -y aws-cfn-bootstrap

      # Tell the Cloudformation policy we're done launching.
      /opt/aws/bin/cfn-signal --stack "${var.ecs_cluster_name}-Autoscaling-Group" --resource "Asg" --region "${data.aws_region.current.name}"
    EOF
  }
}

resource "aws_launch_configuration" "launch_conf" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name_prefix = "${var.environment_name}-ecs"
  image_id = "${data.aws_ami.ecs_ami.id}"
  instance_type = "${var.lc_instance_type}"
  security_groups = [
    "${aws_security_group.ecs_ec2_security_group.id}"
  ]
  key_name = "${aws_key_pair.ecs_key.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs_instance_profile.name}"


  lifecycle {
    create_before_destroy = true
  }

  user_data = "${data.template_cloudinit_config.user_data.rendered}"
}

resource "aws_cloudformation_stack" "asg" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name = "${var.ecs_cluster_name}-Autoscaling-Group"

  lifecycle {
    create_before_destroy = true
    ignore_changes = ["desired_capacity"] // Preserve desired capacity when autoscaled.
  }

  # CloudFormation provides us with AutoScalingRollingUpdate (AWS does not provide this feature to Terraform directly).
  template_body = <<EOF
{
  "Resources": {
    "Asg": {
      "Type": "AWS::AutoScaling::AutoScalingGroup",
      "Properties": {
        "VPCZoneIdentifier": ["${join("\",\"", var.ec2_subnet_ids)}"],
        "LaunchConfigurationName": "${aws_launch_configuration.launch_conf.name}",
        "MaxSize": "${var.max_size}",
        "DesiredCapacity": "${var.desired_capacity}",
        "Cooldown": "${var.default_cooldown}",
        "MinSize": "${var.min_size}",
        "TerminationPolicies": ["OldestLaunchConfiguration", "OldestInstance"],
        "HealthCheckType": "${var.health_check_type}",
        "Tags": [
          {
            "Key": "Name",
            "Value": "${var.environment_name}-ecs-ec2",
            "PropagateAtLaunch": "true"
          },
          {
            "Key": "resource_group",
            "Value": "${var.environment_name}",
            "PropagateAtLaunch": "true"
          }
        ],
        "NotificationConfigurations": [
          {
            "TopicARN": "${var.drain_lambda_sns_arn}",
            "NotificationTypes": [
              "autoscaling:EC2_INSTANCE_LAUNCH",
              "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
              "autoscaling:EC2_INSTANCE_TERMINATE",
              "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
            ]
          }
        ]
      },
      "UpdatePolicy": {
        "AutoScalingRollingUpdate": {
          "MinInstancesInService": "${var.min_size}",
          "MaxBatchSize": "2",
          "PauseTime": "PT10M",
          "WaitOnResourceSignals": "true"
        }
      }
    },
    "ASGTerminateHook": {
      "Type": "AWS::AutoScaling::LifecycleHook",
      "Properties": {
        "AutoScalingGroupName": {"Ref": "Asg"},
        "DefaultResult": "ABANDON",
        "HeartbeatTimeout": "900",
        "LifecycleTransition": "autoscaling:EC2_INSTANCE_TERMINATING",
        "NotificationTargetARN": "${var.drain_lambda_sns_arn}",
        "RoleARN": "${aws_iam_role.asg.arn}"
      }
    }
  },
  "Outputs": {
    "AsgName": {
      "Description": "The name of the auto scaling group",
      "Value": {"Ref": "Asg"}
    }
  }
}
EOF
}
