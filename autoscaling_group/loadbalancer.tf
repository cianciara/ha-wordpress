# aws_lb
resource "aws_lb" "wordpress-alb" {
  name               = "Dev-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = [var.public_subnet_az1_id, var.public_subnet_az2_id]
  ip_address_type    = "ipv4"

  enable_deletion_protection = false

  tags = {
    Name = "Wordpress-ALB"
  }
}

# aws_lb_target_group
resource "aws_lb_target_group" "wordpress-alb-tg" {
  name     = "Dev-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-299"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "Wordpress-ALB-TG"
  }
}

# aws_lb_listener
resource "aws_lb_listener" "alb-http-listener" {
  load_balancer_arn = aws_lb.wordpress-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
      path        = "/#{path}"
      query       = "#{query}"
    }
    target_group_arn = aws_lb_target_group.wordpress-alb-tg.arn
  }

  tags = {
    Name = "Wordpress-HTTP"
  }
}

resource "aws_lb_listener" "alb-https-listener" {
  load_balancer_arn = aws_lb.wordpress-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.cert.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress-alb-tg.arn
  }

  depends_on = [aws_acm_certificate_validation.cert]

  tags = {
    Name = "Wordpress-HTTPS"
  }
}