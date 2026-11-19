# Creating Application Load Balancer
resource "aws_lb" "main" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb-security_id]
  subnets            = var.subnet_ids


  enable_deletion_protection = false
}


# Creating target group defines where to send ALB traffic to
resource "aws_lb_target_group" "target-g" {
  name        = "target-g"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    path                = "/health" # providing health checks
    protocol            = "HTTP"
    port                = "8080"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}


# Creating HTTP listerns
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type = "redirect"

    redirect { # redirects HTTP to HTTPS
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"

    }
  }
}

# Traffic from HTTP get redirect here
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.cert_arn

  default_action {
    type             = "forward" # forwards traffic to the target group
    target_group_arn = aws_lb_target_group.target-g.arn


  }

}









