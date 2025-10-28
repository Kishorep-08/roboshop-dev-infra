# module "catalogue" {
#  source = "terraform-aws-modules/security-group/aws"
#  name = "${local.common_name}-catalogue"
#  description = "Security group for catalogue server"
#  vpc_id = data.aws_ssm_parameter.vpc_id.value

# }

module "sg" {
    count = length(var.sg_names)
    source = "git::https://github.com/Kishorep-08/terraform-aws-sg.git?ref=main"
    project_name = var.project_name
    environment = var.environment
    sg_name = var.sg_names[count.index]
    sg_description = var.sg_description
    vpc_id = local.vpc_id
}

# Frontedn LB to Frontend SG rule

# resource "aws_security_group_rule" "frontend_alb_to_frontend" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   security_group_id = module.sg[9].sg_id  # Frontend SG
#   source_security_group_id = module.sg[11].sg_id  # Frontend LB SG
# }