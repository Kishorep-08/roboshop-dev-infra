# MongoDB
resource "aws_instance" "mongodb" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.mongodb_sg_id]
  subnet_id = local.database_subnet_ids
  tags = merge (
    local.common_tags,
    {
        Name = "${local.common_name}-mongodb"
    }
  )

}

resource "terraform_data" "mongodb" {
  triggers_replace = [
    aws_instance.mongodb.id
  ]

  connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.mongodb.private_ip
  }

  provisioner "file" {
    source = "bootstrap.sh" # Local file path
    destination = "/tmp/bootstrap.sh" # Destination on MongoDb EC2
  }

  provisioner "remote-exec" {
    inline = [
      "echo Hello World!",
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mongodb"
    ]
  }
}

# Redis
resource "aws_instance" "redis" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.redis_sg_id]
  subnet_id = local.database_subnet_ids
  tags = merge (
    local.common_tags,
    {
        Name = "${local.common_name}-redis"
    }
  )

}

resource "terraform_data" "redis" {
  triggers_replace = [
    aws_instance.redis.id
  ]

  connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.redis.private_ip
  }

  provisioner "file" {
    source = "bootstrap.sh" # Local file path
    destination = "/tmp/bootstrap.sh" # Destination on redis EC2
  }

  provisioner "remote-exec" {
    inline = [
      "echo Hello World!",
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh redis"
    ]
  }
}

# RabbitMQ

resource "aws_instance" "rabbitmq" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.rabbitmq_sg_id]
  subnet_id = local.database_subnet_ids
  tags = merge (
    local.common_tags,
    {
        Name = "${local.common_name}-rabbitmq"
    }
  )

}

resource "terraform_data" "rabbitmq" {
  triggers_replace = [
    aws_instance.rabbitmq.id
  ]

  connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.rabbitmq.private_ip
  }

  provisioner "file" {
    source = "bootstrap.sh" # Local file path
    destination = "/tmp/bootstrap.sh" # Destination on rabbitmq EC2
  }

  provisioner "remote-exec" {
    inline = [
      "echo Hello World!",
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh rabbitmq"
    ]
  }
}

# MySQL

resource "aws_instance" "mysql" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  vpc_security_group_ids = [local.mysql_sg_id]
  subnet_id = local.database_subnet_ids
  iam_instance_profile = "EC2SSM"
  tags = merge (
    local.common_tags,
    {
        Name = "${local.common_name}-mysql"
    }
  )

}

resource "aws_iam_instance_profile" "mysql" {
  name = "mysql"
  role = "EC2SSM"
}

resource "terraform_data" "mysql" {
  triggers_replace = [
    aws_instance.mysql.id
  ]

  connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.mysql.private_ip
  }

  provisioner "file" {
    source = "bootstrap.sh" # Local file path
    destination = "/tmp/bootstrap.sh" # Destination on mysql EC2
  }

  provisioner "remote-exec" {
    inline = [
      "echo Hello World!",
      "chmod +x /tmp/bootstrap.sh",
      "sudo sh /tmp/bootstrap.sh mysql dev"
    ]
  }
}

# Route53 record for MongoDB

resource "aws_route53_record" "mongodb" {
  zone_id = data.aws_route53_zone.hosted_zone_id.zone_id
  name    = "mongodb-${var.environment}.${var.domain_name}"  # mongodb-dev.kishore-p.space
  type    = "A"
  ttl     = 1
  records = [aws_instance.mongodb.private_ip]
}

# Route53 record for Redis

resource "aws_route53_record" "redis" {
  zone_id = data.aws_route53_zone.hosted_zone_id.zone_id
  name    = "redis-${var.environment}.${var.domain_name}"  # redis-dev.kishore-p.space
  type    = "A"
  ttl     = 1
  records = [aws_instance.redis.private_ip]
}

# Route53 record for RabbitMQ
resource "aws_route53_record" "rabbitmq" {
  zone_id = data.aws_route53_zone.hosted_zone_id.zone_id
  name    = "rabbitmq-${var.environment}.${var.domain_name}"  # rabbitmq-dev.kishore-p.space
  type    = "A"
  ttl     = 1
  records = [aws_instance.rabbitmq.private_ip]
}

# Route53 record for MySQL
resource "aws_route53_record" "mysql" {
  zone_id = data.aws_route53_zone.hosted_zone_id.zone_id
  name    = "mysql-${var.environment}.${var.domain_name}"  # mysql-dev.kishore-p.space
  type    = "A"
  ttl     = 1
  records = [aws_instance.mysql.private_ip]
}