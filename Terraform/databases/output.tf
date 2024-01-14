output "rds_password" {
  value = aws_db_instance.postgres-db.password
}

output "rds_endpoint" {
  value = aws_db_instance.postgres-db.address
}