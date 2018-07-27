data "aws_ami" "ami" {
  owners = ["self"]

  most_recent = true

  filter {
    name   = "name"
    values = ["nulogy-rabbitmq-*"]
  }
}
