data "aws_availability_zones" "availability_zones" {}

resource "aws_subnet" "ecs_private_subnet_1" {
  vpc_id = "${var.vpc_id}"
  availability_zone = "${data.aws_availability_zones.availability_zones.names[0]}"
  cidr_block = "${var.ecs_private_subnet_1}"

  tags {
    Name = "${var.environment_name} private subnet 1"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_subnet" "ecs_private_subnet_2" {
  vpc_id = "${var.vpc_id}"
  availability_zone = "${data.aws_availability_zones.availability_zones.names[1]}"
  cidr_block = "${var.ecs_private_subnet_2}"

  tags {
    Name = "${var.environment_name} private subnet 2"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_eip" "eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.eip.id}"
  subnet_id = "${aws_subnet.ecs_public_subnet_1.id}"

  depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_route_table" "ecs_private_routing_table" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_gw.id}"
  }

  tags {
    Name = "${var.environment_name} private subnet routing table"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_route_table_association" "ecs_private_route_table_association_1" {
  route_table_id = "${aws_route_table.ecs_private_routing_table.id}"
  subnet_id = "${aws_subnet.ecs_private_subnet_1.id}"
}

resource "aws_route_table_association" "ecs_private_route_table_association_2" {
  route_table_id = "${aws_route_table.ecs_private_routing_table.id}"
  subnet_id = "${aws_subnet.ecs_private_subnet_2.id}"
}

resource "aws_subnet" "ecs_public_subnet_1" {
  vpc_id = "${var.vpc_id}"
  availability_zone = "${data.aws_availability_zones.availability_zones.names[0]}"
  cidr_block = "${var.public_subnet_1}"

  tags {
    Name = "${var.environment_name} public subnet 1"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_subnet" "ecs_public_subnet_2" {
  vpc_id = "${var.vpc_id}"
  availability_zone = "${data.aws_availability_zones.availability_zones.names[1]}"
  cidr_block = "${var.public_subnet_2}"

  tags {
    Name = "${var.environment_name} public subnet 2"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_route_table" "ecs_public_routing_table" {
  vpc_id = "${var.vpc_id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${var.internet_gw_id}"
  }

  tags {
    Name = "${var.environment_name} public subnet routing table"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_route_table_association" "ecs_public_route_table_association_1" {
  route_table_id = "${aws_route_table.ecs_public_routing_table.id}"
  subnet_id = "${aws_subnet.ecs_public_subnet_1.id}"
}

resource "aws_route_table_association" "ecs_public_route_table_association_2" {
  route_table_id = "${aws_route_table.ecs_public_routing_table.id}"
  subnet_id = "${aws_subnet.ecs_public_subnet_2.id}"
}
