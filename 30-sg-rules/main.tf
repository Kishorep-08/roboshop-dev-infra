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
  security_group_id = local.bastion_sg_id  # Bastion SG
  cidr_blocks       =  ["0.0.0.0/0"]
}


# MongoDB accepting connections from bastion
resource "aws_security_group_rule" "mongodb_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = local.mongodb_sg_id  # mongodb SG
  source_security_group_id = local.bastion_sg_id # Bastion sg
}


# Redis accepting connections from bastion
resource "aws_security_group_rule" "redis_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = local.redis_sg_id  # redis SG
  source_security_group_id = local.bastion_sg_id # Bastion sg
}

# RabbitMQ accepting connections from bastion
resource "aws_security_group_rule" "rabbitmq_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = local.rabbitmq_sg_id  # rabbitmq SG
  source_security_group_id = local.bastion_sg_id # Bastion sg
}

# MySQL accepting connections from bastion
resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = local.mysql_sg_id  # mysql SG
  source_security_group_id = local.bastion_sg_id # Bastion sg
}

# Catalogue accepting connections from bastion
resource "aws_security_group_rule" "catalogue_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = local.catalogue_sg_id  # catalogue SG
  source_security_group_id = local.bastion_sg_id # Bastion sg
}