output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = module.aurora_postgresql_basic.cluster_arn
}

output "cluster_id" {
  description = "The RDS Cluster Identifier"
  value       = module.aurora_postgresql_basic.cluster_id
}

output "cluster_identifier" {
  description = "The RDS Cluster Identifier"
  value       = module.aurora_postgresql_basic.cluster_identifier
}

output "writer_endpoint" {
  description = "The DNS address of the RDS instance"
  value       = module.aurora_postgresql_basic.writer_endpoint
}

output "reader_endpoint" {
  description = "A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas"
  value       = module.aurora_postgresql_basic.reader_endpoint
}

output "db_arns" {
  description = "Amazon Resource Name (ARN) of cluster instances."
  value       = module.aurora_postgresql_basic.db_arns
}

output "db_identifiers" {
  description = "The Instance identifiers."
  value       = module.aurora_postgresql_basic.db_identifiers
}

output "db_ids" {
  description = "The Instance identifiers."
  value       = module.aurora_postgresql_basic.db_ids
}