output "vpc_peering_connection_id" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_vpc_peering_connection.vpc_peering_connection.*.id, list("")), 0)}"
}