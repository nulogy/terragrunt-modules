resource "aws_security_group" "rabbitmq_elb" {
    name        = "${var.environment_name} RabbitMQ ELB"
    vpc_id      = "${var.vpc_id}"
    description = "Security Group for the RabbitMQ ELB"

    tags {
        Name = "${var.environment_name} Rabbitmq ELB"
        resource_group = "${var.environment_name}"
    }
}

resource "aws_security_group_rule" "RabbitMQ_ELB_Allow_egress_to_anywhere" {
    type = "egress"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    security_group_id = "${aws_security_group.rabbitmq_elb.id}"

    cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_security_group_rule" "RabbitMQ_ELB_Allow_ingress_for_AMQP_to_anywhere" {
    type = "ingress"
    from_port = 5671
    to_port = 5671
    protocol = "tcp"
    security_group_id = "${aws_security_group.rabbitmq_elb.id}"

    cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_security_group_rule" "RabbitMQ_ELB_Allow_ingress_for_RabbitMQ_Management_API_to_anywhere" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_group_id = "${aws_security_group.rabbitmq_elb.id}"

    cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_security_group" "rabbitmq" {
    name        = "${var.environment_name} RabbitMQ Servers"
    vpc_id      = "${var.vpc_id}"
    description = "Security Group for the RabbitMQ Servers"

    tags {
        Name = "${var.environment_name} Rabbitmq"
        resource_group = "${var.environment_name}"
    }
}

resource "aws_security_group_rule" "RabbitMQ_Allow_egress_to_anywhere" {
    type = "egress"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    security_group_id = "${aws_security_group.rabbitmq.id}"

    cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_security_group_rule" "RabbitMQ_Allow_ingress_for_AMQP_to_ELB" {
    type = "ingress"
    from_port = 5671
    to_port = 5671
    protocol = "tcp"
    security_group_id = "${aws_security_group.rabbitmq.id}"

    source_security_group_id = "${aws_security_group.rabbitmq_elb.id}"
}

resource "aws_security_group_rule" "RabbitMQ_Allow_ingress_for_RabbitMQ_Management_API_to_ELB" {
    type = "ingress"
    from_port = 15671
    to_port = 15671
    protocol = "tcp"
    security_group_id = "${aws_security_group.rabbitmq.id}"

    source_security_group_id = "${aws_security_group.rabbitmq_elb.id}"
}

resource "aws_security_group_rule" "RabbitMQ_Allow_ingress_for_SSH_to_Nulogy_Office" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_group_id = "${aws_security_group.rabbitmq.id}"

    cidr_blocks = [ "${var.allowed_ssh_cidr_block}" ]
}

resource "aws_security_group_rule" "RabbitMQ_Allow_ingress_for_internode_communication" {
    type = "ingress"
    from_port = 4369
    to_port = 4369
    protocol = "tcp"
    security_group_id = "${aws_security_group.rabbitmq.id}"

    source_security_group_id = "${aws_security_group.rabbitmq_elb.id}"
}