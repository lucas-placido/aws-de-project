// parameter group 
// rds.force_ssl -> 0
// rds.logical_replication -> 1
// https://github.com/dbeaver/dbeaver/issues/21616

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_db_instance" "postgres-db" {
  allocated_storage    = 10
  db_name              = "mydb"
  identifier = "postgres"
  engine               = "postgres"
  engine_version       = "15.4"
  instance_class       = "db.t3.micro"
  username             = var.rds-username
  password             = var.rds-password
  
  publicly_accessible = true
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_default_vpc.default.default_security_group_id]
  parameter_group_name = aws_db_parameter_group.custom-pg.name
}

resource "aws_db_parameter_group" "custom-pg" {
  name   = "rds-pg"
  family = "postgres15"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "rds.logical_replication"
    value = "1"
    apply_method = "pending-reboot"
  }
}