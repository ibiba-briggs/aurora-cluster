#--------------------------------------------------
# *** Shared Arguments for cluster and instance ***
#--------------------------------------------------
variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window."
  type        = bool
  default     = false
}

variable "name" {
  description = "Desired name for cluster & resources being created."
  type        = string
}

variable "db_subnet_group_name" {
  description = "A DB subnet group to associate with this DB instance."
  type        = string
  default     = ""
}

variable "engine" {
  description = "The name of the database engine to be used for this DB cluster. Defaults to aurora. Valid Values: aurora, aurora-mysql, aurora-postgresql."
  type        = string
  default     = "aurora-mysql"
}

variable "engine_version" {
  description = "The database engine version. Updating this argument results in an outage."
  type        = string
  default     = "5.7.mysql_aurora.2.09.2"
}

variable "preferred_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur, in (UTC)."
  type        = string
  default     = "sat:07:00-sat:08:00"
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

#-----------------------------------
# AWS RDS Cluster Specific Arguments
#-----------------------------------
variable "allow_major_version_upgrade" {
  description = "Enable to allow major engine version upgrades when changing engine versions. Defaults to false."
  type        = bool
  default     = false
}

variable "availability_zones" {
  description = "The availability zones used by cluster."
  type        = list(string)
  default     = [] 
}

variable "backtrack_window" {
  description = "The target backtrack window, in seconds. Only available for aurora engine currently. To disable backtracking, set this value to 0. Defaults to 0. Must be between 0 and 259200 (72 hours)."
  type        = number
  default     = 0
}

variable "backup_retention_period" {
  description = "The days to retain backups for."
  type        = number
  default     = 5
}

variable "copy_tags_to_snapshot" {
  description = "Copy all Cluster tags to snapshots. "
  type        = bool
  default     = false  
}

variable "database_name" {
  description = "Name for an automatically created database on cluster creation."
  type        = string
  default     = "aurora"
}

variable "db_cluster_parameter_group_name" {
  description = "A cluster parameter group to associate with the cluster."
  type        = string
  default     = ""
}

variable "deletion_protection" {
  description = "Protection from accidental deletion at cluster level."
  type        = bool
  default     = true
}

variable "enable_http_endpoint" {
  description = "Enable HTTP endpoint (data API). Only valid when engine_mode is set to serverless."
  type        = bool
  default     = false 
}

variable "enabled_cloudwatch_logs_exports" {
  description = "Set of log types to export to cloudwatch. If omitted, no logs will be exported. The following log types are supported: audit, error, general, slowquery, postgresql (PostgreSQL)."
  type        = list(string)
  default     = []
}

variable "engine_mode" {
  description = "The database engine mode. Valid values: global (only valid for Aurora MySQL 1.21 and earlier), multimaster, parallelquery, provisioned, serverless. Defaults to: provisioned."
  type        = string
  default     = "provisioned"
}

variable "global_cluster_identifier" {
  description = "The global cluster identifier specified on aws_rds_global_cluster."
  type        = string
  default     = ""
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled."
  type        = bool
  default     = false
}

variable "iam_roles" {
  description = "A List of ARNs for the IAM roles to associate to the RDS Cluster."
  type        = list(string)
  default     = []
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. When specifying kms_key_id, storage_encrypted needs to be set to true."
  type        = string
  default     = ""
}

variable "master_password" {
  description = "Master DB password."
  type        = string
}

variable "master_username" {
  description = "Master DB username."
  type        = string
  default     = "master"
}

variable "port" {
  description = "The port on which the DB accepts connections."
  type        = string
  default     = ""
}

variable "preferred_backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled."
  type        = string
  default     = "04:00-05:00"
}

variable "replication_source_identifier" {
  description = "ARN of a source DB cluster or DB instance if this DB cluster is to be created as a Read Replica."
  type        = string
  default     = ""
}

variable "scaling_configuration" {
  description = "(engine_mode serverless) Nested attribute with scaling properties."
  type        = map(string)
  default     = {}

  # Attributes
  # ----------
  # auto_pause
  # max_capacity
  # min_capacity
  # seconds_until_auto_pause
  # timeout_action
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted."
  type        = bool
  default     = false 
}

variable "snapshot_identifier" {
  description = "Specifies whether or not to create this cluster from a snapshot."
  type        = string
  default     = ""
}

variable "source_region" {
  description = "The source region for an encrypted replica DB cluster."
  type        = string
  default     = ""
}

variable "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted. The default is false for provisioned engine_mode and true for serverless engine_mode. When restoring an unencrypted snapshot_identifier, the kms_key_id argument must be provided to encrypt the restored cluster. Terraform will only perform drift detection if a configuration value is provided."
  type        = bool
  default     = false
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate with the Cluster."
  type        = list(string)
  default     = []
}

#---------------------------------------
# AWS RDS DB Instance Specific Arguments
#---------------------------------------
variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window."
  type        = bool
  default     = false
}

variable "availability_zone" {
  description = "The EC2 Availability Zone that the DB instance is created in."
  type        = string
  default     = ""
}

variable "ca_cert_identifier" {
  description = "The identifier of the CA certificate for the DB instance."
  type        = string
  default     = "rds-ca-2019"
}

variable "db_parameter_group_name" {
  description = "The name of the DB parameter group to associate with this instance."
  type        = string
  default     = "" 
}

variable "instance_class_master" {
  description = "The instance class to use as master."
  type        = string
  default     = "db.r5.large"
}

variable "instance_class_replica" {
  description = "The instance class to use as the read replica. If not set will default to instance_class_master."
  type        = string
  default     = ""
}

variable "instance_count" {
  description = "Creates additional read replicas. When replica_scale_enable argument is true, replica_scale_min is used."
  type        = number
  default     = 1
}

variable "instance_settings" {
  description = "Customized instance settings. Supported keys: instance_name, instance_az, instance_class, instance_promotion_tier, publicly_accessible."
  type        = list(map(string))
  default     = []
  # instance_name           = identifier: The identifier for the RDS instance.
  # instance_az             = The EC2 Availability Zone that the DB instance is created in.
  # instance_class          = instance_class: The instance class to use. 
  # instance_promotion_tier = promotion_tier: Default 0. Failover Priority setting on instance level. The reader who has lower tier has higher priority to get promoted to writer.
  # publicly_accessible     = publicly_accessible: Bool to control if instance is publicly accessible. Default false.
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60."
  type        = number
  default     = 0
}

variable "monitoring_role_arn" {
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs."
  type        = string
  default     = ""
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights is enabled or not."
  type        = bool
  default     = false
}

variable "performance_insights_kms_key_id" {
  description = "The ARN for the KMS key to encrypt Performance Insights data. When specifying performance_insights_kms_key_id, performance_insights_enabled needs to be set to true."
  type        = string
  default     = ""
}

variable "promotion_tier" {
  description = "Default 0. Failover Priority setting on instance level."
  type        = number
  default     = 0
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible."
  type        = bool
  default     = false
}

#----------------------------------------------
# Autoscaling Arguments For MySQL Read Replicas
#----------------------------------------------
variable "replica_scale_enabled" {
  description = "Enable autoscaling for RDS Aurora (MySQL) read replicas."
  type        = bool
  default     = false
}

variable "replica_scale_max" {
  description = "Maximum number of replicas to allow scaling for."
  type        = number
  default     = 4
}

variable "replica_scale_min" {
  description = "Minimum number of replicas to allow scaling for."
  type        = number
  default     = 2
}

variable "replica_scale_cpu" {
  description = "CPU usage to trigger autoscaling at."
  type        = number
  default     = 70
}

variable "replica_scale_connections" {
  description = "Average number of connections to trigger autoscaling at. Default value is 70% of db.r4.large's default max_connections."
  type        = number
  default     = 700
}

variable "replica_scale_in_cooldown" {
  description = "Cooldown in seconds before allowing further scaling operations after a scale in."
  type        = number
  default     = 300
}

variable "replica_scale_out_cooldown" {
  description = "Cooldown in seconds before allowing further scaling operations after a scale out."
  type        = number
  default     = 300
}

variable "predefined_metric_type" {
  description = "The metric type to scale on. Valid values are RDSReaderAverageCPUUtilization and RDSReaderAverageDatabaseConnections."
  type        = string
  default     = "RDSReaderAverageCPUUtilization"
}

#--------------------------
# Parameter Group Arguments
#--------------------------
variable "create_cluster_parameter_group" {
  description = "Create RDS parameters groups for cluster and instance."
  type        = bool
  default     = false
}

variable "parameter_group_family" {
  description = "The family of the parameter group."
  type        = string
  default     = ""
}

variable "cluster_parameters" {
  description = "A list of Cluster parameters to apply."
  type        = list(map(string))
  default     = []
}


variable "create_db_parameter_group" {
  description = "Create RDS parameters groups for cluster and instance."
  type        = bool
  default     = false
}

variable "db_parameters" {
  description = "A list of DB instance parameters to apply."
  type        = list(map(string))
  default     = []
}

#-----------------------
# Subnet group Arguments
#-----------------------
variable "create_subnet_group" {
  description = "Enable the creation db subnet groups."
  type        = bool
  default     = false
}

variable "subnet_group_ids" {
  description = "A list of VPC subnet IDs."
  type        = list(string)
  default     = []
}
