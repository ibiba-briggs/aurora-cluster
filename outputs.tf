output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = aws_rds_cluster.aurora.arn
}

output "cluster_id" {
  description = "The RDS Cluster Identifier"
  value       = aws_rds_cluster.aurora.id
}

output "cluster_identifier" {
  description = "The RDS Cluster Identifier"
  value       = aws_rds_cluster.aurora.cluster_identifier
}

output "writer_endpoint" {
  description = "The DNS address of the RDS instance"
  value       = aws_rds_cluster.aurora.endpoint
}

output "reader_endpoint" {
  description = "A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas"
  value       = aws_rds_cluster.aurora.reader_endpoint
}

output "db_arns" {
  description = "Amazon Resource Name (ARN) of cluster instances."
  value       = aws_rds_cluster_instance.aurora.*.arn
}

output "db_identifiers" {
  description = "The Instance identifiers."
  value       = aws_rds_cluster_instance.aurora.*.identifier
}

output "db_ids" {
  description = "The Instance identifiers."
  value       = aws_rds_cluster_instance.aurora.*.id
}

