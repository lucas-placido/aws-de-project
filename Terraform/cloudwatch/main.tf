resource "aws_cloudwatch_log_group" "firehose_destination_log_group" {
  name = "firehose/destination"

  tags = {
    Environment = "Dev"
    Application = "firehose-delivery-stream"
  }
}

resource "aws_cloudwatch_log_stream" "cloudwatch_s3_stream" {
  name           = "s3"
  log_group_name = aws_cloudwatch_log_group.firehose_destination_log_group.name
}