# Bakcend alb facing frontend (accepts traffic from frontend)
resource "aws_lb" "backend_alb" {
  name               = "${local.common_name}-backend-alb" # roboshop-dev-backend-alb
  internal           = true
  load_balancer_type = "application"
  security_groups    = [local.backend_alb_sg_id]
  subnets            = local.private_subnet_ids

  enable_deletion_protection = true

  tags = merge(
    local.common_tags,
    {
        Name = "${local.common_name}-backend-alb"
    }
  )
}

# backend load balancer listening on port 80
resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.backend_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Hi, I am from backend alb"
      status_code  = "200"
    }
  }
}

# Route53 record for backend alb
resource "aws_route53_record" "backend_alb" {
  zone_id = local.zone_id
  name    = "*.backend-alb-${var.environment}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.backend_alb.dns_name
    zone_id                = aws_lb.backend_alb.zone_id
    evaluate_target_health = true
  }
}

