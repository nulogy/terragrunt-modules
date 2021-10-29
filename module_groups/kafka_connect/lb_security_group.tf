resource "aws_security_group" "lb_security_group" {
  name_prefix = "${local.normalized_service_name}-lb-sg-kafka connect"

  vpc_id = module.vpc.vpc_id

  ingress {
    cidr_blocks      = concat(var.kafka_connect__additional_ingress_cidrs, [module.vpc.vpc_cidr])
    ipv6_cidr_blocks = [module.vpc.vpc_cidr_ipv6]
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
  }

  # Allows all outbound traffic
  egress {
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
  }

  tags = {
    Name           = "${local.normalized_service_name} kafka connect load balancer security group"
    resource_group = local.normalized_service_name
  }

  lifecycle {
    create_before_destroy = true
  }
}
