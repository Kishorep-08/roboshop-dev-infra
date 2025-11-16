resource "aws_instance" "catalogue" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.catalogue_sg_id]
  subnet_id = local.private_subnet_ids
  tags = merge (
    local.common_tags,
    {
        Name = "${local.common_name}-catalogue"
    }
  )

}

resource "terraform_data" "catalogue" {
  triggers_replace = [
    aws_instance.catalogue.id
  ]

  connection {
    type = "ssh"
    user = "${aws_ssm_parameter.ami_uname.value}"
    password = "${aws_ssm_parameter.ami_pwd.value}"
    host = "${aws_instance.catalogue.private_ip}"
  }

  provisioner "file" {
    source = "catalogue.sh" # Local file path
    destination = "/tmp/catalogue.sh" # Destination on catalogue EC2
  }

  provisioner "remote-exec" {
    inline = [
      "echo Hello World!",
      "chmod +x /tmp/catalogue.sh",
      "sudo sh /tmp/catalogue.sh catalogue ${var.environment}"
    ]
  }
}

# Stopping catalogue instance to take AMI
resource "aws_ec2_instance_state" "catalogue" {
instance_id = "${aws_instance.catalogue.id}" 
state       = "stopped"
depends_on = [terraform_data.catalogue]  
}           

# To take AMI from catalogue instance
resource "aws_ami_from_instance" "catalogue-ami" {
  name               = "${local.common_name}" # roboshop-dev-catalogue-ami
  source_instance_id = "${aws_instance.catalogue.id}"
  depends_on = [aws_ec2_instance_state.catalogue]
  tags = merge (
    local.common_tags,
    {
        Name = "${local.common_name}-catalogue"
    }
  )
}

# Target group for catalogue
resource "aws_lb_target_group" "catalogue" {
  name     = "${local.common_name}-catalogue-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  deregistration_delay = 60
  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200-299"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  } 
}

# Launch template for catalogue autoscaling
resource "aws_launch_template" "catalogue" {
  name = "${local.common_name}-catalogue"

  image_id = "aws_ami_from_instance.catalogue-ami.id"

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t3.micro"

  vpc_security_group_ids = ["local.catalogue_sg_id"]

  tag_specifications {
    resource_type = "instance"
    # Tags for EC2 instances launched from this template
    tags = merge (
    local.common_tags,
    {
        Name = "${local.common_name}-catalogue"
    }
  )
  }
 # Launch template tags
 tags = merge (
    local.common_tags,
    {
        Name = "${local.common_name}-catalogue"
    }
  )  
}

# Autoscaling group for catalogue
resource "aws_placement_group" "test" {
  name     = "test"
  strategy = "cluster"
}

resource "aws_autoscaling_group" "catalogue" {
  name                      = "${local.common_name}-catalogue"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = false
  launch_template {
    id      = aws_launch_template.catalogue.id
    version = aws_launch_template.catalogue.latest_version
  }
  vpc_zone_identifier       = local.vpc_zone_identifier
  target_group_arns         = [aws_lb_target_group.catalogue-tg]

  dynamic "tag" {
    for_each = merge(
      local.common_tags,
      {
        Name = "${local.common_name}-catalogue"
      }
    )
    content {
      key                 = "each.key"
      value               = "each.value"
      propagate_at_launch = true
    }
  }
}

resource "aws_autoscaling_policy" "catalogue" {
  autoscaling_group_name = "${aws_autoscaling_group.catalogue.name}"
  name                   = "${local.common_name}-catalogue"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 75.0
  }
}