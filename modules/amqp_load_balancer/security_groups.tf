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
