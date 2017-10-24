data "aws_availability_zones" "available" {}

resource "aws_subnet" "rds_subnet_1" {
  vpc_id = "${var.vpc_id}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  cidr_block = "${var.rds_private_subnet_1}"

  tags {
    Name = "${var.environment_name} RDS subnet 1"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_subnet" "rds_subnet_2" {
  vpc_id = "${var.vpc_id}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
  cidr_block = "${var.rds_private_subnet_2}"

  tags {
    Name = "${var.environment_name} RDS subnet 2"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name_prefix = "${var.environment_name}-rds-subnet-group-"
  subnet_ids = ["${aws_subnet.rds_subnet_1.id}", "${aws_subnet.rds_subnet_2.id}"]

  tags {
    Name = "${var.environment_name} RDS subnet group"
    resource_group = "${var.environment_name}"
  }
}
