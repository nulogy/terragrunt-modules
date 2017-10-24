resource "aws_security_group" "bastion_security_group" {
  count = 0

  name_prefix = "${var.environment_name}-bastion-sg-"
  vpc_id = "${var.vpc_id}"

  # Allows only SSH connections through office VPN
  ingress {
    cidr_blocks = ["${var.nulogy_office_ip}/32"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

  # SSH responses to the office
  egress {
    cidr_blocks = ["${var.nulogy_office_ip}/32"]
    from_port = 0
    to_port = 65535
    protocol = "tcp"
  }

  # Allows all connections to our AWS infrastructure via VPC
  egress {
    cidr_blocks = ["${var.vpc_cidr}"]
    from_port = 0
    to_port = 65535
    protocol = "tcp"
  }

  tags {
    Name = "${var.environment_name} Bastion security group"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_launch_configuration" "bastion_launch_conf" {
  count = 0
  name_prefix = "${var.environment_name}-bastion"
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
}

resource "aws_instance" "bastion_instance" {
  count = 0

  ami = "ami-ea87a78f"
  instance_type = "t2.nano"
  security_groups = ["${aws_security_group.bastion_security_group.id}"]
  associate_public_ip_address = true
  subnet_id = "${aws_subnet.ecs_public_subnet_1.id}"
  key_name = "${aws_key_pair.ecs_key.key_name}"

  tags {
    Name = "${var.environment_name} Bastion"
    resource_group = "${var.environment_name}"
  }
}
