data "aws_acm_certificate" "acm_region_cert" {
  domain = "*.${var.certificate_domain}"
  most_recent = true
}

resource "aws_elb" "elb" {
  name = "${var.environment_name}-RabbitMQ-ELB"

  listener {
    instance_port     = 5671
    instance_protocol = "tcp"
    lb_port           = 5671
    lb_protocol       = "tcp"
  }

  listener {
    instance_port      = 15671
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = data.aws_acm_certificate.acm_region_cert.arn
  }

  health_check {
    interval            = 30
    unhealthy_threshold = 10
    healthy_threshold   = 2
    timeout             = 3
    target              = "TCP:5671"
  }

  subnets      = var.public_subnet_ids
  idle_timeout = 3600
  internal     = false
  security_groups = [
    aws_security_group.rabbitmq_elb.id,
  ]

  tags = {
    Name           = "${var.environment_name} RabbitMQ ELB"
    resource_group = var.environment_name
  }
}

