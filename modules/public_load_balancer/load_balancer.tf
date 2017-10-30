resource "aws_alb" "public_load_balancer" {
  name = "${var.environment_name}-PLB"
  internal = false
  security_groups = ["${aws_security_group.ecs_lb_security_group.id}"]
  subnets = ["${var.alb_subnets}"]

  tags {
    Name = "${var.environment_name} public load balancer"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_alb_target_group" "target_group" {
  name = "${var.environment_name}-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.environment_name} public load balancer target group"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_alb_listener" "public_lb_listener" {
  load_balancer_arn = "${aws_alb.public_load_balancer.arn}"
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = "${var.region_cert_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.target_group.arn}"
    type = "forward"
  }
}
