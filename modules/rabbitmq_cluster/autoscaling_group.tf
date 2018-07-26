data "aws_vpc" "vpc" {
  id = "${var.vpc_id}"
}

resource "aws_launch_configuration" "rabbitmq" {
    name_prefix          = "${var.environment_name} RabbitMQ Launch configuration"
    image_id             = "${data.aws_ami.ami.id}"
    instance_type        = "${var.instance_type}"
    key_name             = "${aws_key_pair.key_pair.key_name}"
    security_groups      = [
        "${aws_security_group.rabbitmq.id}"
    ]
    iam_instance_profile = "${aws_iam_instance_profile.rabbitmq_profile.id}"

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "rabbitmq" {
    name_prefix               = "${var.environment_name}-${aws_launch_configuration.rabbitmq.name}-RabbitMQ"
    max_size                  = "${var.count * 2}"
    min_size                  = "${var.count}"
    desired_capacity          = "${var.count}"
    health_check_grace_period = 300
    health_check_type         = "ELB"
    force_delete              = true
    launch_configuration      = "${aws_launch_configuration.rabbitmq.name}"
    load_balancers            = ["${aws_elb.elb.name}"]
    vpc_zone_identifier       = ["${var.private_subnet_ids}"]

    tag  = [
        {
            key = "Name"
            value = "${var.environment_name} RabbitMQ"
            propagate_at_launch = true
        },
        {
            key = "resource_group"
            value = "${var.environment_name}"
            propagate_at_launch = true
        }
    ]

    lifecycle {
        create_before_destroy = true
    }
}
