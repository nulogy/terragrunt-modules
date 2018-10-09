locals {
  lc_instance_type = "${length(var.lc_instance_type) > 0 ? var.lc_instance_type : "t2.nano"}"
  asg_name = "${var.environment_name}-bastion"
}

data "aws_ami" "ecs_ami" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  filter {
    name = "name"
    values = ["${var.ecs_ami}"]
  }

  owners = ["${var.ecs_ami_owner}"]
}

resource "aws_launch_configuration" "launch_conf" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  associate_public_ip_address = true
  name_prefix = "${var.environment_name}-bastion"
  image_id = "${data.aws_ami.ecs_ami.id}"
  instance_type = "${local.lc_instance_type}"
  security_groups = [
    "${aws_security_group.ecs_ec2_security_group.id}"
  ]
  key_name = "${aws_key_pair.bastion_key.key_name}"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "asg" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name_prefix = "${var.environment_name}-${aws_launch_configuration.launch_conf.name}-autoscaling-group"
  desired_capacity = "1"
  max_size = "1"
  min_size = "1"
  min_elb_capacity = "1"
  launch_configuration = "${aws_launch_configuration.launch_conf.name}"
  vpc_zone_identifier = ["${var.ec2_subnet_ids}"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key = "Name"
    value = "${local.asg_name}"
    propagate_at_launch = "true"
  }

  tag {
    key = "resource_group"
    value = "${var.environment_name}"
    propagate_at_launch = true
  }
}
