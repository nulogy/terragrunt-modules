output "private_subnet_ids" {
  value = ["${aws_subnet.private_subnets.*.id}"]
}

output "private_routing_table_ids" {
  value = ["${aws_route_table.private_routing_tables.*.id}"]
}