locals {

    common_name = "${var.project_name}-${var.environment}"
    frontend_alb_sg_id = data.aws_ssm_parameter.frontend_alb_sg_id.value
    public_subnet_ids = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
    common_tags = {
        Project = var.project_name
        Environment = var.environment
    }
    zone_id = data.aws_route53_zone.hosted_zone_id.zone_id
    certificate_arn = data.aws_ssm_parameter.certificate_arn.value
    
}