output "public_subnet_ids" {
  value = ["${aws_subnet.public_subnets.*.id}"]
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private_subnets.*.id}"]
}

output "nat_gateway_public_ips" {
  value = ["${aws_nat_gateway.nat_gateways.*.public_ip}"]
}
