# Terraform Aurora Cluster Module

Terraform module for the creation of an Aurora Cluster.

## Description

This module is designed to assist the user in the creation of an Aurora Cluster. Please be sure to check out the examples and test the potential design requirements for your Team.

## Examples

- [MySQL Autoscaling](aurora_examples/mysql_autoscaling): An example usage for autocaling. Possibly a preferred example for reporting or an application with heavy reads.
- [MySQL Basic](aurora_examples/mysql_basic): An example of basic usage for mysql.
- [MySQL Custom](aurora_examples/mysql_custom): An example of mysql custom instance settings usage.
- [PostgreSQL Basic](aurora_examples/postgresql_custom): An example of basic usage for postgresql.
- [PostgreSQL Custom](aurora_examples/postgresql_custom): An example of postgresql custom instance settings usage.
- [Serverless](aurora_examples/serverless): An example of mysql serverless usage.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6 |
| aws | >= 3.8 |
| random | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.8 |
| random | >= 3.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_appautoscaling_policy](https://registry.terraform.io/providers/hashicorp/aws/3.8/docs/resources/appautoscaling_policy) |
| [aws_appautoscaling_target](https://registry.terraform.io/providers/hashicorp/aws/3.8/docs/resources/appautoscaling_target) |
| [aws_db_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/3.8/docs/resources/db_parameter_group) |
| [aws_db_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/3.8/docs/resources/db_subnet_group) |
| [aws_rds_cluster](https://registry.terraform.io/providers/hashicorp/aws/3.8/docs/resources/rds_cluster) |
| [aws_rds_cluster_instance](https://registry.terraform.io/providers/hashicorp/aws/3.8/docs/resources/rds_cluster_instance) |
| [aws_rds_cluster_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/3.8/docs/resources/rds_cluster_parameter_group) |
| [random_id](https://registry.terraform.io/providers/hashicorp/random/3.0/docs/resources/id) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| allow\_major\_version\_upgrade | Enable to allow major engine version upgrades when changing engine versions. Defaults to false. | `bool` | `false` | no |
| apply\_immediately | Specifies whether any database modifications are applied immediately, or during the next maintenance window. | `bool` | `false` | no |
| auto\_minor\_version\_upgrade | Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window. | `bool` | `false` | no |
| availability\_zone | The EC2 Availability Zone that the DB instance is created in. | `string` | `""` | no |
| availability\_zones | The availability zones used by cluster. | `list(string)` | `[]` | no |
| backtrack\_window | The target backtrack window, in seconds. Only available for aurora engine currently. To disable backtracking, set this value to 0. Defaults to 0. Must be between 0 and 259200 (72 hours). | `number` | `0` | no |
| backup\_retention\_period | The days to retain backups for. | `number` | `5` | no |
| ca\_cert\_identifier | The identifier of the CA certificate for the DB instance. | `string` | `"rds-ca-2019"` | no |
| cluster\_parameters | A list of Cluster parameters to apply. | `list(map(string))` | `[]` | no |
| copy\_tags\_to\_snapshot | Copy all Cluster tags to snapshots. | `bool` | `false` | no |
| create\_cluster\_parameter\_group | Create RDS parameters groups for cluster and instance. | `bool` | `false` | no |
| create\_db\_parameter\_group | Create RDS parameters groups for cluster and instance. | `bool` | `false` | no |
| create\_subnet\_group | Enable the creation db subnet groups. | `bool` | `false` | no |
| database\_name | Name for an automatically created database on cluster creation. | `string` | `"aurora"` | no |
| db\_cluster\_parameter\_group\_name | A cluster parameter group to associate with the cluster. | `string` | `""` | no |
| db\_parameter\_group\_name | The name of the DB parameter group to associate with this instance. | `string` | `""` | no |
| db\_parameters | A list of DB instance parameters to apply. | `list(map(string))` | `[]` | no |
| db\_subnet\_group\_name | A DB subnet group to associate with this DB instance. | `string` | `""` | no |
| deletion\_protection | Protection from accidental deletion at cluster level. | `bool` | `true` | no |
| enable\_http\_endpoint | Enable HTTP endpoint (data API). Only valid when engine\_mode is set to serverless. | `bool` | `false` | no |
| enabled\_cloudwatch\_logs\_exports | Set of log types to export to cloudwatch. If omitted, no logs will be exported. The following log types are supported: audit, error, general, slowquery, postgresql (PostgreSQL). | `list(string)` | `[]` | no |
| engine | The name of the database engine to be used for this DB cluster. Defaults to aurora. Valid Values: aurora, aurora-mysql, aurora-postgresql. | `string` | `"aurora-mysql"` | no |
| engine\_mode | The database engine mode. Valid values: global (only valid for Aurora MySQL 1.21 and earlier), multimaster, parallelquery, provisioned, serverless. Defaults to: provisioned. | `string` | `"provisioned"` | no |
| engine\_version | The database engine version. Updating this argument results in an outage. | `string` | `"5.7.mysql_aurora.2.09.1"` | no |
| global\_cluster\_identifier | The global cluster identifier specified on aws\_rds\_global\_cluster. | `string` | `""` | no |
| iam\_database\_authentication\_enabled | Specifies whether mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled. | `bool` | `false` | no |
| iam\_roles | A List of ARNs for the IAM roles to associate to the RDS Cluster. | `list(string)` | `[]` | no |
| instance\_class\_master | The instance class to use as master. | `string` | `"db.r5.large"` | no |
| instance\_class\_replica | The instance class to use as the read replica. If not set will default to instance\_class\_master. | `string` | `""` | no |
| instance\_count | Creates additional read replicas. When replica\_scale\_enable argument is true, replica\_scale\_min is used. | `number` | `1` | no |
| instance\_settings | Customized instance settings. Supported keys: instance\_name, instance\_az, instance\_class, instance\_promotion\_tier, publicly\_accessible. | `list(map(string))` | `[]` | no |
| kms\_key\_id | The ARN for the KMS encryption key. When specifying kms\_key\_id, storage\_encrypted needs to be set to true. | `string` | `""` | no |
| master\_password | Master DB password. | `string` | n/a | yes |
| master\_username | Master DB username. | `string` | `"master"` | no |
| monitoring\_interval | The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60. | `number` | `0` | no |
| monitoring\_role\_arn | The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs. | `string` | `""` | no |
| name | Desired name for cluster & resources being created. | `string` | n/a | yes |
| parameter\_group\_family | The family of the parameter group. | `string` | `""` | no |
| performance\_insights\_enabled | Specifies whether Performance Insights is enabled or not. | `bool` | `false` | no |
| performance\_insights\_kms\_key\_id | The ARN for the KMS key to encrypt Performance Insights data. When specifying performance\_insights\_kms\_key\_id, performance\_insights\_enabled needs to be set to true. | `string` | `""` | no |
| port | The port on which the DB accepts connections. | `string` | `""` | no |
| predefined\_metric\_type | The metric type to scale on. Valid values are RDSReaderAverageCPUUtilization and RDSReaderAverageDatabaseConnections. | `string` | `"RDSReaderAverageCPUUtilization"` | no |
| preferred\_backup\_window | The daily time range (in UTC) during which automated backups are created if they are enabled. | `string` | `"04:00-05:00"` | no |
| preferred\_maintenance\_window | The weekly time range during which system maintenance can occur, in (UTC). | `string` | `"sat:07:00-sat:08:00"` | no |
| promotion\_tier | Default 0. Failover Priority setting on instance level. | `number` | `0` | no |
| publicly\_accessible | Bool to control if instance is publicly accessible. | `bool` | `false` | no |
| replica\_scale\_connections | Average number of connections to trigger autoscaling at. Default value is 70% of db.r4.large's default max\_connections. | `number` | `700` | no |
| replica\_scale\_cpu | CPU usage to trigger autoscaling at. | `number` | `70` | no |
| replica\_scale\_enabled | Enable autoscaling for RDS Aurora (MySQL) read replicas. | `bool` | `false` | no |
| replica\_scale\_in\_cooldown | Cooldown in seconds before allowing further scaling operations after a scale in. | `number` | `300` | no |
| replica\_scale\_max | Maximum number of replicas to allow scaling for. | `number` | `4` | no |
| replica\_scale\_min | Minimum number of replicas to allow scaling for. | `number` | `2` | no |
| replica\_scale\_out\_cooldown | Cooldown in seconds before allowing further scaling operations after a scale out. | `number` | `300` | no |
| replication\_source\_identifier | ARN of a source DB cluster or DB instance if this DB cluster is to be created as a Read Replica. | `string` | `""` | no |
| scaling\_configuration | (engine\_mode serverless) Nested attribute with scaling properties. | `map(string)` | `{}` | no |
| skip\_final\_snapshot | Determines whether a final DB snapshot is created before the DB cluster is deleted. | `bool` | `false` | no |
| snapshot\_identifier | Specifies whether or not to create this cluster from a snapshot. | `string` | `""` | no |
| source\_region | The source region for an encrypted replica DB cluster. | `string` | `""` | no |
| storage\_encrypted | Specifies whether the DB cluster is encrypted. The default is false for provisioned engine\_mode and true for serverless engine\_mode. When restoring an unencrypted snapshot\_identifier, the kms\_key\_id argument must be provided to encrypt the restored cluster. Terraform will only perform drift detection if a configuration value is provided. | `bool` | `false` | no |
| subnet\_group\_ids | A list of VPC subnet IDs. | `list(string)` | `[]` | no |
| tags | A map of tags to assign to the resource. | `map(string)` | `{}` | no |
| vpc\_security\_group\_ids | List of VPC security groups to associate with the Cluster. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_arn | Amazon Resource Name (ARN) of cluster |
| cluster\_id | The RDS Cluster Identifier |
| cluster\_identifier | The RDS Cluster Identifier |
| db\_arns | Amazon Resource Name (ARN) of cluster instances. |
| db\_identifiers | The Instance identifiers. |
| db\_ids | The Instance identifiers. |
| reader\_endpoint | A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas |
| writer\_endpoint | The DNS address of the RDS instance |
