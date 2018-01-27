output "vpc_id" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_vpc.vpc.*.id, list("")), 0)}"
}

output "internet_gw_id" {
  #https://github.com/hashicorp/terraform/issues/16726
  value = "${element(concat(aws_internet_gateway.gw.*.id, list("")), 0)}"
}
