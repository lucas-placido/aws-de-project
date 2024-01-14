# resource "random_integer" "random_number" {
#   min     = 100
#   max     = 999
# }
# ${random_integer.random_number.result}

resource "aws_s3_bucket" "relational_storage" {  
  bucket = "dms-target-791" 

  tags = {
    Name        = "RDS Postgres Data"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "streaming_storage" {
  bucket = "ec2-target-791"

  tags = {
    Name        = "EC2/Kinesis Firehose Data"
    Environment = "Dev"
  }
}