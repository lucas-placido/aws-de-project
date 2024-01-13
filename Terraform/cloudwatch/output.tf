output "cloudwatch_group" {
  value = aws_cloudwatch_log_group.firehose_destination_log_group.name
}

output "cloudwatch_stream" {
  value = aws_cloudwatch_log_stream.cloudwatch_s3_stream.name
}