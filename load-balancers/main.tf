resource "aws_lb_target_group" "frontend_lb_http_tg" {
  name     = "Frontend-LB-HTTP-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/VenturaMailingApp.php"
    port                = "traffic-port"
    protocol            = "HTTP"
  }
}

resource "aws_lb" "frontend_lb" {
  name               = "Prod-Frontend-LB"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.frontend_lb_subnet_ids
  security_groups   = [aws_security_group.frontend_lb_sg.id]

  enable_deletion_protection = false  

  enable_http2 = true  

  enable_cross_zone_load_balancing = true

  enable_access_logs = false  

  #enable_deletion_protection = false  

  tags = {
    Name = "Prod-Frontend-LB"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "frontend_lb_listener" {
  load_balancer_arn = aws_lb.frontend_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "OK"
    }
  }
}

resource "aws_security_group" "backend_lb_sg" {
  name        = var.backend_lb_sg_name
  description = "Backend Load Balancer Security Group"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = [80, 443]
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = [aws_security_group.Webserver_sg.id]
    }
  }
}

resource "aws_lb_target_group" "backend_lb_http_tg" {
  name     = "Backend-LB-HTTP-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    path                = "/VenturaMailingApp.php"
    port                = "traffic-port"
    protocol            = "HTTP"
  }
}

resource "aws_lb" "backend_lb" {
  name               = "Prod-Backend-LB"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.backend_lb_subnet_ids
  security_groups   = [aws_security_group.backend_lb_sg.id]

  enable_deletion_protection = false  

  enable_http2 = true  

  enable_cross_zone_load_balancing = true

  enable_access_logs = false  

  #enable_deletion_protection = false  # Set to true if you want deletion protection

  tags = {
    Name = "Prod-Backend-LB"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "backend_lb_listener" {
  load_balancer_arn = aws_lb.backend_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "OK"
    }
  }
}
