output "vpc_security_group_ids" {
  value = aws_default_vpc.default.default_security_group_id
}

output "rds_password" {
  value = aws_db_instance.postgres-db.password
}

output "rds_endpoint" {
  value = aws_db_instance.postgres-db.address
}