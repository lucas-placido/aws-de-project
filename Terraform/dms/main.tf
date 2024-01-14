resource "aws_dms_replication_instance" "replication" {
  allocated_storage            = 20
  apply_immediately            = true
  auto_minor_version_upgrade   = true
  engine_version               = "3.5.2"  
  multi_az                     = false
  publicly_accessible          = true
  replication_instance_class   = "dms.t2.micro"
  replication_instance_id      = "replication-instance"

  tags = {
    Name = "test"
  }

  vpc_security_group_ids = [
    var.security_group_allow_tls_id
  ]

}

# Create a new endpoint
resource "aws_dms_endpoint" "rds-endpoint" {
  server_name = var.rds_endpoint
  database_name               = "mydb"
  endpoint_id                 = "rds"
  endpoint_type               = "source"
  engine_name                 = "postgres"    
  password                    = var.rds_password
  port                        = 5432
  ssl_mode                    = "none"

  tags = {
    Name = "test"
  }

  username = "postgres"
}

resource "aws_dms_s3_endpoint" "example" {
  endpoint_id             = "s3-bucket"
  endpoint_type           = "target"
  bucket_name             = var.bucket_name
  service_access_role_arn = var.s3-role
}

# Create a new replication task
resource "aws_dms_replication_task" "dms-task" {  
  migration_type            = "full-load-and-cdc"
  replication_instance_arn  = aws_dms_replication_instance.replication.replication_instance_arn
  replication_task_id       = "replication-task"  
  source_endpoint_arn       = aws_dms_endpoint.rds-endpoint.endpoint_arn
table_mappings = <<TABLE_MAPPINGS
{
  "rules": [
    {
      "rule-type": "selection",
      "rule-id": "1",
      "rule-name": "1",
      "object-locator": {
        "schema-name": "%",
        "table-name": "%"
      },
      "rule-action": "include"
    }
  ]
}
TABLE_MAPPINGS

  tags = {
    Name = "test"
  }

  target_endpoint_arn = aws_dms_s3_endpoint.example.endpoint_arn
  depends_on = [ aws_dms_endpoint.rds-endpoint, aws_dms_s3_endpoint.example ]
}