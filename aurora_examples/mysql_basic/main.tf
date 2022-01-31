provider "aws" {
  region = "us-east-1"
}

locals {
  instance_class_master = {
    "lowers"     = "db.t3.medium"
    "production" = "db.r5.large"
  }

  instance_class_replica = {
    "lowers"     = "db.t3.medium"
    "production" = "db.r5.large"
  }
  name = "aurora-mysql-basic"
}

module "aurora_mysql_basic" {
  source = "../../"

  apply_immediately      = true
  availability_zones     = var.availability_zones
  database_name          = "aurora"
  deletion_protection    = false
  engine                 = "aurora-mysql"
  engine_version         = "5.7.mysql_aurora.2.09.1"
  instance_count         = 2
  instance_class_master  = local.instance_class_master[var.environment]
  instance_class_replica = local.instance_class_replica[var.environment]
  master_username        = var.master_username
  master_password        = var.master_password
  name                   = local.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.aurora-sg.id]

  create_subnet_group = true
  subnet_group_ids    = var.subnet_group_ids

  tags = var.tags
}

resource "aws_security_group" "aurora-sg" {
  name        = "${local.name}-aurora-sg"
  description = "Allow MySQL connections"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}