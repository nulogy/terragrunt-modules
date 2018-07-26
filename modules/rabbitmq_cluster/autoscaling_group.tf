data "aws_vpc" "vpc" {
  id = "${var.vpc_id}"
}

data "template_file" "RabbitMQ_User_data" {
  template = "${file("${path.module}/files/user_data.sh.tpl")}"

  vars {
    environment_name = "${var.environment_name}"
    aws_region = "${var.aws_region}"
    node_count = "${var.count}"
    message_timeout = "60"
  }
}

resource "aws_launch_configuration" "rabbitmq" {
  name_prefix          = "${var.environment_name} RabbitMQ Launch configuration"
  image_id             = "${data.aws_ami.ami.id}"
  instance_type        = "${var.instance_type}"
  key_name             = "${aws_key_pair.key_pair.key_name}"
  security_groups      = [
    "${aws_security_group.rabbitmq.id}"
  ]
  user_data = "${data.template_file.RabbitMQ_User_data.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.rabbitmq_profile.id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudformation_stack" "rabbitmq" {
  name = "${var.environment_name}-RabbitMQ-autoscaling"

  # CloudFormation provides us with AutoScalingRollingUpdate (AWS does not provide this feature to Terraform directly).
  template_body = <<EOF
{
  "Resources": {
    "RabbitMQAsg": {
      "Type": "AWS::AutoScaling::AutoScalingGroup",
      "Properties": {
        "VPCZoneIdentifier": ["${join("\",\"", var.private_subnet_ids)}"],
        "LaunchConfigurationName": "${aws_launch_configuration.rabbitmq.name}",
        "MaxSize": "${var.count + 1}",
        "DesiredCapacity": "${var.count}",
        "MinSize": "${var.count}",
        "MetricsCollection": [{
            "Granularity": "1Minute",
            "Metrics": [ "GroupMinSize", "GroupMaxSize", "GroupInServiceInstances", "GroupTotalInstances" ]
        }],
        "LoadBalancerNames": ["${aws_elb.elb.name}"],
        "TerminationPolicies": ["OldestLaunchConfiguration", "OldestInstance"],
        "HealthCheckType": "ELB",
        "HealthCheckGracePeriod": 300,
        "Tags": [
          {
            "Key": "Name",
            "Value": "${var.environment_name} RabbitMQ",
            "PropagateAtLaunch": "true"
          },
          {
            "Key": "resource_group",
            "Value": "${var.environment_name}",
            "PropagateAtLaunch": "true"
          },
          {
            "Key": "server_type",
            "Value": "rabbitmq",
            "PropagateAtLaunch": "true"
          }
        ]
      },
      "UpdatePolicy": {
        "AutoScalingRollingUpdate": {
          "MinInstancesInService": "${var.count}",
          "MaxBatchSize": "1",
          "PauseTime": "PT10M",
          "WaitOnResourceSignals": true
        }
      }
    }
  },
  "Outputs": {
    "AsgName": {
      "Description": "The name of the auto scaling group",
       "Value": {"Ref": "RabbitMQAsg"}
    }
  }
}
EOF
}
