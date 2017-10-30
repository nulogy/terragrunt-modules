output "public_subnets" {
  value = ["${aws_subnet.public_subnets.*.id}"]
}

output "private_subnets" {
  value = ["${aws_subnet.private_subnets.*.id}"]
}