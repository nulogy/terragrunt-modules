resource "aws_lb" "public_load_balancer" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name = "${var.environment_name}-PLB"
  internal = false
  security_groups = ["${aws_security_group.ecs_lb_security_group.id}"]
  subnets = ["${var.alb_subnets}"]

  tags {
    Name = "${var.environment_name} public load balancer"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_lb_target_group" "target_group" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  name = "${var.environment_name}-tg"
  port = "${var.port}"
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"
  deregistration_delay = 120
  target_type = "${var.target_type}"

  health_check {
    path = "${var.health_check_path}"
  }

  stickiness {
    enabled = "${var.stickiness_enabled}"
    type = "lb_cookie"
    cookie_duration = "${var.stickiness_duration}"
  }

  tags {
    Name = "${var.environment_name} public load balancer target group"
    resource_group = "${var.environment_name}"
  }
}

resource "aws_lb_listener" "public_lb_listener" {
  count = "${length(var.skip) > 0 ? 0 : 1}"

  load_balancer_arn = "${aws_lb.public_load_balancer.arn}"
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = "${data.aws_acm_certificate.acm_region_cert.arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.target_group.arn}"
    type = "forward"
  }
}
