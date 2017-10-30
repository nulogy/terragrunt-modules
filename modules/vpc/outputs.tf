output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "internet_gw_id" {
  value = "${aws_internet_gateway.gw.id}"
}