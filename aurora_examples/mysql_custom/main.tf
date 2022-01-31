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
  name = "aurora-mysql-custom"
}

module "aurora_mysql_custom" {
  source = "../../"

  #allow_major_version_upgrade = true <-test inline upgrades for major versions
  apply_immediately      = true
  availability_zones     = var.availability_zones
  database_name          = "aurora"
  deletion_protection    = false
  engine                 = "aurora-mysql" #"aurora" <-test inline upgrades for major versions
  engine_version         = "5.7.mysql_aurora.2.09.1" #"5.6.mysql_aurora.1.22.2" <-test inline upgrades for major versions
  master_username        = var.master_username
  master_password        = var.master_password
  name                   = local.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.aurora-sg.id]

  create_subnet_group = true
  subnet_group_ids    = var.subnet_group_ids

  create_cluster_parameter_group = true
  parameter_group_family = "aurora-mysql5.7" #"aurora5.6" <-test inline upgrades for major versions
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

  instance_settings = [
    # instance_count argument is not required if instance_settings is used
    {
      instance_name  = "primary"
      instance_az    = "us-east-1a"
      instance_class = local.instance_class_master[var.environment]
    },
    {
      instance_name  = "secondary"
      instance_az    = "us-east-1b"
      instance_class = local.instance_class_replica[var.environment]
    },
    {
      instance_name           = "replica"
      instance_az             = "us-east-1c"
      instance_class          = local.instance_class_replica[var.environment]
      instance_promotion_tier = 15
    }
  ]

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