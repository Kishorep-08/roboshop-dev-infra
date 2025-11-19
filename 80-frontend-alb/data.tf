data "aws_ssm_parameter" "frontend_alb_sg_id" {
  name = "/${var.project_name}/${var.environment}/frontend_alb_sg_id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/public_subnet_ids"
}

data "aws_route53_zone" "hosted_zone_id" {
  name         = "kishore-p.space"
  private_zone = false
}

data "aws_ssm_parameter" "certificate_arn" {
  name = "/${var.project_name}/${var.environment}/certificate_arn"
}