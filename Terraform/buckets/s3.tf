resource "aws_s3_bucket" "storage" {
  bucket = "dms-target-232"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}