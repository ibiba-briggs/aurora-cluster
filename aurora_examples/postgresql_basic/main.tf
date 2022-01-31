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

  name = "aurora-postgres"
}

module "aurora_postgresql_basic" {
  source = "../../"

  apply_immediately      = true
  availability_zones     = var.availability_zones
  database_name          = "aurora"
  deletion_protection    = false
  engine                 = "aurora-postgresql"
  engine_version         = "12.4"
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
    from_port   = 5432
    to_port     = 5432
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