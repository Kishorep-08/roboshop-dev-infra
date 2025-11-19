# Bakcend alb facing frontend (accepts traffic from frontend)
resource "aws_lb" "frontend_alb" {
  name               = "${local.common_name}-frontend-alb" # roboshop-dev-backend-alb
  internal           = false
  load_balancer_type = "application"
  security_groups    = [local.frontend_alb_sg_id]
  subnets            = local.public_subnet_ids

  enable_deletion_protection = true

  tags = merge(
    local.common_tags,
    {
        Name = "${local.common_name}-frontend-alb"
    }
  )
}

# frontend load balancer listening on port 443
resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.frontend_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06" 
  certificate_arn   = "${local.certificate_arn}"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hi, I am from frontend alb"
      status_code  = "200"
    }
  }
}


resource "aws_lb_listener_certificate" "roboshop" {
  listener_arn    = aws_lb_listener.frontend.arn
  certificate_arn = local.certificate_arn
}

# Route53 record for frontend alb
resource "aws_route53_record" "frontend_alb" {
  zone_id = local.zone_id
  name    = "${var.project_name}-${var.environment}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.frontend_alb.dns_name
    zone_id                = aws_lb.frontend_alb.zone_id
    evaluate_target_health = true
  }
}

