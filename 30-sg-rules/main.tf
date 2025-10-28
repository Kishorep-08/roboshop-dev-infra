# Backend ALB accepting traffic from bastion
resource "aws_security_group_rule" "backend_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = local.backend_alb_sg_id  # Backend alb SG
  source_security_group_id = local.bastion_sg_id  # bastion SG
}

# Bastion accepting traffic from my laptop
resource "aws_security_group_rule" "bastion_laptop" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = local.bastion_sg_id  # Bastion alb SG
  cidr_blocks       =  ["0.0.0.0/0"]
}