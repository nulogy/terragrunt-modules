data "aws_ami" "ecs_ami" {
  filter {
    name = "name"
    values = ["amzn-ami-${var.ecs_ami_version}-amazon-ecs-optimized"]
  }

  owners = ["591542846629"]
}

resource "aws_launch_configuration" "go_launch_conf" {
  name_prefix = "${var.environment_name}-ecs"
  image_id = "${data.aws_ami.ecs_ami.id}"
  instance_type = "${var.lc_instance_type}"
  security_groups = [
    "${aws_security_group.ecs_ec2_security_group.id}"
  ]
  key_name = "${aws_key_pair.ecs_key.key_name}"
  iam_instance_profile = "ecsInstanceRole"


  lifecycle {
    create_before_destroy = true
  }

  user_data = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${var.environment_name}-ecs-cluster >> /etc/ecs/ecs.config
EOF
}

resource "aws_autoscaling_group" "go_asg" {
  name_prefix = "${var.environment_name}-${aws_launch_configuration.go_launch_conf.name}-autoscaling-group"
  max_size = 4
  min_size = 2
  min_elb_capacity = 2
  health_check_grace_period = 300
  health_check_type = "ELB"
  desired_capacity = 2
  launch_configuration = "${aws_launch_configuration.go_launch_conf.name}"
  vpc_zone_identifier = ["${aws_subnet.ecs_private_subnet_1.id}", "${aws_subnet.ecs_private_subnet_2.id}"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key = "Name"
    value = "${var.environment_name}-ecs-ec2"
    propagate_at_launch = "true"
  }

  tag {
    key = "resource_group"
    value = "${var.environment_name}"
    propagate_at_launch = true
  }
}
