resource "aws_s3_bucket" "relational_storage" {
  bucket = "dms-target-234"

  tags = {
    Name        = "RDS Postgres Data"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "streaming_storage" {
  bucket = "ec2-target-234"

  tags = {
    Name        = "EC2/Kinesis Firehose Data"
    Environment = "Dev"
  }
}