provider "aws" {
  region = "us-east-1"
}

locals {
  name = "aurora-serverless"
}

module "aurora_serverless" {
  source = "../../"

  apply_immediately      = true
  availability_zones     = var.availability_zones
  database_name          = "aurora"
  deletion_protection    = false
  engine                 = "aurora-mysql"
  engine_mode            = "serverless"
  engine_version         = "5.7.mysql_aurora.2.07.1"
  master_username        = var.master_username
  master_password        = var.master_password
  name                   = local.name
  skip_final_snapshot    = true
  storage_encrypted      = true
  vpc_security_group_ids = [aws_security_group.aurora-sg.id]

  create_subnet_group = true
  subnet_group_ids    = var.subnet_group_ids

  create_cluster_parameter_group = true
  parameter_group_family = "aurora-mysql5.7"
  cluster_parameters = [
    {
      name  = "max_connections"
      value = "500"
    },
    {
      name         = "performance_schema"
      value        = "1"
      apply_method = "pending-reboot"
    }
  ]

  scaling_configuration = {
    auto_pause               = true
    min_capacity             = 2 #4GB mem
    max_capacity             = 8 #16GB mem
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }

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