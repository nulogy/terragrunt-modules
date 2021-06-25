locals {
  security_group_ids = length(var.security_group_ids) > 0 ? var.security_group_ids : [aws_security_group.ecs_lb_security_group[0].id]
}

resource "aws_lb" "public_load_balancer" {
  count = length(var.skip) > 0 ? 0 : 1

  name            = "${var.environment_name}-PLB"
  internal        = var.internal
  security_groups = local.security_group_ids
  subnets         = var.alb_subnets
  ip_address_type = var.ip_address_type

  tags = {
    Name           = "${var.environment_name} public load balancer"
    resource_group = var.environment_name
  }
}

resource "aws_lb_target_group" "target_group_green" {
  count = length(var.skip) > 0 ? 0 : 1

  name                 = "${var.environment_name}-tg-green"
  port                 = var.port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = var.deregistration_delay
  target_type          = var.target_type
  slow_start           = var.slow_start

  health_check {
    path    = var.health_check_path
    timeout = var.health_check_timeout
    matcher = "200"
  }

  stickiness {
    enabled         = var.stickiness_enabled
    type            = "lb_cookie"
    cookie_duration = var.stickiness_duration
  }

  tags = {
    Name           = "${var.environment_name} public load balancer target group green"
    resource_group = var.environment_name
  }
}

resource "aws_lb_target_group" "target_group_blue" {
  count = length(var.skip) > 0 ? 0 : 1

  name                 = "${var.environment_name}-tg-blue"
  port                 = var.port
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = var.deregistration_delay
  target_type          = var.target_type
  slow_start           = var.slow_start

  health_check {
    path    = var.health_check_path
    timeout = var.health_check_timeout
    matcher = "200"
  }

  stickiness {
    enabled         = var.stickiness_enabled
    type            = "lb_cookie"
    cookie_duration = var.stickiness_duration
  }

  tags = {
    Name           = "${var.environment_name} public load balancer target group blue"
    resource_group = var.environment_name
  }
}

resource "aws_lb_listener" "public_lb_listener" {
  count = length(var.skip) > 0 ? 0 : 1

  load_balancer_arn = aws_lb.public_load_balancer[0].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = length(var.lb_cert_arn) > 0 ? var.lb_cert_arn : data.aws_acm_certificate.acm_region_cert[0].arn

  default_action {
    target_group_arn = aws_lb_target_group.target_group_green[0].arn
    type             = "forward"
  }

  lifecycle {
    ignore_changes = [default_action]
  }
}

resource "aws_lb_listener_rule" "default_routing" {
  listener_arn = aws_lb_listener.public_lb_listener[0].arn
  priority     = var.lb_maintenance_mode ? 49999 : 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_green[0].arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  lifecycle {
    ignore_changes = [action]
  }
}

resource "aws_lb_listener_rule" "maintenance_routing" {
  listener_arn = aws_lb_listener.public_lb_listener[0].arn
  priority     = var.lb_maintenance_mode ? 2 : 50000

  action {
    type = "fixed-response"

    fixed_response {
      content_type = var.lb_maintenance_mode_content_type
      message_body = var.lb_maintenance_mode_page_content
      status_code  = var.lb_maintenance_mode_status_code
    }
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}
