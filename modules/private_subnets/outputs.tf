output "private_subnets" {
  value = ["${aws_subnet.private_subnets.*.id}"]
}