output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = module.aurora_serverless.cluster_arn
}

output "cluster_id" {
  description = "The RDS Cluster Identifier"
  value       = module.aurora_serverless.cluster_id
}

output "cluster_identifier" {
  description = "The RDS Cluster Identifier"
  value       = module.aurora_serverless.cluster_identifier
}

output "writer_endpoint" {
  description = "The DNS address of the RDS instance"
  value       = module.aurora_serverless.writer_endpoint
}

output "reader_endpoint" {
  description = "A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas"
  value       = module.aurora_serverless.reader_endpoint
}