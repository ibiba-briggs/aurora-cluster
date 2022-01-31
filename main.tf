locals {
  backtrack_window                = (var.engine == "aurora-mysql" || var.engine == "aurora") && var.engine_mode != "serverless" ? var.backtrack_window : 0
  db_cluster_parameter_group_name = var.create_cluster_parameter_group ? element(concat(aws_rds_cluster_parameter_group.cluster_param_grp.*.id,[""]),0) : var.db_cluster_parameter_group_name
  db_parameter_group_name         = var.create_db_parameter_group ? element(concat(aws_db_parameter_group.db_param_grp.*.id,[""]),0) : var.db_parameter_group_name
  db_subnet_group_name            = var.create_subnet_group ? element(concat(aws_db_subnet_group.subnet_grp.*.id,[""]),0) : var.db_subnet_group_name
  instance_count                  = length(var.instance_settings) > 0 ? length(var.instance_settings) : var.instance_count
  port                            = var.port == "" ? var.engine == "aurora-postgresql" ? "5432" : "3306" : var.port
}

# -----------------------
# Aurora Cluster Creation
# -----------------------
resource "aws_rds_cluster" "aurora" {
  
  allow_major_version_upgrade         = var.allow_major_version_upgrade
  apply_immediately                   = var.apply_immediately
  availability_zones                  = var.availability_zones
  backtrack_window                    = local.backtrack_window
  backup_retention_period             = var.backup_retention_period
  cluster_identifier                  = var.name
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  database_name                       = var.database_name
  db_cluster_parameter_group_name     = local.db_cluster_parameter_group_name
  db_subnet_group_name                = local.db_subnet_group_name
  deletion_protection                 = var.deletion_protection
  enable_http_endpoint                = var.enable_http_endpoint
  enabled_cloudwatch_logs_exports     = var.enabled_cloudwatch_logs_exports
  engine_mode                         = var.engine_mode
  engine_version                      = var.engine_version
  engine                              = var.engine
  final_snapshot_identifier           = "${var.name}-${random_id.snapshot.hex}-final"
  global_cluster_identifier           = var.global_cluster_identifier
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  iam_roles                           = var.iam_roles
  kms_key_id                          = var.kms_key_id
  master_password                     = var.master_password
  master_username                     = var.master_username
  port                                = local.port
  preferred_backup_window             = var.preferred_backup_window
  preferred_maintenance_window        = var.preferred_maintenance_window
  replication_source_identifier       = var.replication_source_identifier
  skip_final_snapshot                 = var.skip_final_snapshot
  snapshot_identifier                 = var.snapshot_identifier
  source_region                       = var.source_region
  storage_encrypted                   = var.storage_encrypted
  vpc_security_group_ids              = var.vpc_security_group_ids

  dynamic "scaling_configuration" {
    for_each = length(keys(var.scaling_configuration)) == 0 ? [] : [var.scaling_configuration]

    content {
      auto_pause               = lookup(scaling_configuration.value, "auto_pause", null)
      max_capacity             = lookup(scaling_configuration.value, "max_capacity", null)
      min_capacity             = lookup(scaling_configuration.value, "min_capacity", null)
      seconds_until_auto_pause = lookup(scaling_configuration.value, "seconds_until_auto_pause", null)
      timeout_action           = lookup(scaling_configuration.value, "timeout_action", null)
    }
  }

  tags = var.tags
}

resource "random_id" "snapshot" {
  keepers = {
    id = var.name
  }

  byte_length = 4
}

# ------------------------
# Aurora Instance Creation
# ------------------------
resource "aws_rds_cluster_instance" "aurora" {
  count = var.engine_mode != "serverless" ? (var.replica_scale_enabled ? var.replica_scale_min : local.instance_count) : 0

  apply_immediately               = var.apply_immediately
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  availability_zone               = length(var.instance_settings) > count.index ? lookup(var.instance_settings[count.index], "instance_az", var.availability_zone) : var.availability_zone
  ca_cert_identifier              = var.ca_cert_identifier
  cluster_identifier              = aws_rds_cluster.aurora.cluster_identifier
  db_parameter_group_name         = local.db_parameter_group_name
  db_subnet_group_name            = local.db_subnet_group_name
  engine                          = var.engine
  engine_version                  = var.engine_version
  identifier                      = length(var.instance_settings) > count.index ? lookup(var.instance_settings[count.index], "instance_name", "${var.name}-${count.index}") : "${var.name}-${count.index}"
  instance_class                  = length(var.instance_settings) > count.index ? lookup(var.instance_settings[count.index], "instance_class", var.instance_class_master) : count.index > 0 ? coalesce(var.instance_class_replica, var.instance_class_master) : var.instance_class_master
  monitoring_interval             = var.monitoring_interval
  monitoring_role_arn             = var.monitoring_role_arn
  performance_insights_enabled    = var.performance_insights_enabled
  performance_insights_kms_key_id = var.performance_insights_kms_key_id
  publicly_accessible             = length(var.instance_settings) > count.index ? lookup(var.instance_settings[count.index], "publicly_accessible", var.publicly_accessible) : var.publicly_accessible
  preferred_maintenance_window    = var.preferred_maintenance_window
  promotion_tier                  = length(var.instance_settings) > count.index ? lookup(var.instance_settings[count.index], "instance_promotion_tier", var.promotion_tier) : var.promotion_tier

  # Engine version changes forces replacement of db instances.
  # Cluster level will update instances instead when the engine version is updated 
  lifecycle {
    ignore_changes = [
      engine_version
    ]
  }

  tags = var.tags
}

# ------------------------------------
# Aurora Instance Autoscaling Creation
# ------------------------------------
resource "aws_appautoscaling_target" "read_replica_capacity" {
  count = var.replica_scale_enabled ? 1 : 0

  max_capacity       = var.replica_scale_max
  min_capacity       = var.replica_scale_min
  resource_id        = "cluster:${aws_rds_cluster.aurora.cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"
}

resource "aws_appautoscaling_policy" "autoscaling_read_replicas" {
  count = var.replica_scale_enabled ? 1 : 0

  name               = var.name
  policy_type        = "TargetTrackingScaling"
  resource_id        = "cluster:${aws_rds_cluster.aurora.cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.predefined_metric_type
    }

    scale_in_cooldown  = var.replica_scale_in_cooldown
    scale_out_cooldown = var.replica_scale_out_cooldown
    target_value       = var.predefined_metric_type == "RDSReaderAverageCPUUtilization" ? var.replica_scale_cpu : var.replica_scale_connections
  }

  depends_on = [aws_appautoscaling_target.read_replica_capacity]
}

# ---------------------------------------
# Aurora Cluster Parameter Group Creation
# ---------------------------------------
resource "aws_rds_cluster_parameter_group" "cluster_param_grp" {
  count = var.create_cluster_parameter_group ? 1 : 0

  name        = replace("${var.name}-${var.parameter_group_family}", ".", "-")
  description = "Managed by Terraform"
  family      = var.parameter_group_family

  dynamic "parameter" {
    for_each = var.cluster_parameters

    content {
      name         = lookup(parameter.value, "name", null)
      value        = lookup(parameter.value, "value", null)
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# ----------------------------------------
# Aurora Instance Parameter Group Creation
# ----------------------------------------
resource "aws_db_parameter_group" "db_param_grp" {
  count = var.create_db_parameter_group ? 1 : 0

  name        = replace("${var.name}-${var.parameter_group_family}", ".", "-")
  description = "Managed by Terraform"
  family      = var.parameter_group_family

  dynamic "parameter" {
    for_each = var.db_parameters

    content {
      name         = lookup(parameter.value, "name", null)
      value        = lookup(parameter.value, "value", null)
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# ----------------------------
# Aurora Subnet Group Creation
# ----------------------------
resource "aws_db_subnet_group" "subnet_grp" {
  count = var.create_subnet_group ? 1 : 0

  name        = var.name
  subnet_ids  = var.subnet_group_ids
  description = "Managed by Terraform"

  tags = var.tags
}