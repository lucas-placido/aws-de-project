output "bucket-name" {
  value = aws_s3_bucket.relational_storage.bucket
}

output "firehose_bucket_arn" {
  value = aws_s3_bucket.streaming_storage.arn
}

output "ec2_bucket" {
  value = aws_s3_bucket.streaming_storage
}