output "dmsIP" {
  value = aws_dms_replication_instance.replication.replication_instance_private_ips
}
