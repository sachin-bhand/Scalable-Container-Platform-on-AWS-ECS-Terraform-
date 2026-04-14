output "db_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.safle_db.endpoint
}

output "db_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.safle_db.address
}

output "db_port" {
  description = "The port of the RDS instance"
  value       = aws_db_instance.safle_db.port
}

output "db_name" {
  description = "The database name"
  value       = aws_db_instance.safle_db.db_name
}