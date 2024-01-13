resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
  name        = "firehose-delivery-stream"
  destination = "extended_s3"
  
  extended_s3_configuration {
    role_arn   = var.firehose_role
    bucket_arn =var.destination_bucket_arn
    
    cloudwatch_logging_options {
      enabled = true
      log_group_name = var.cloudwatch_group
      log_stream_name = var.cloudwatch_stream
    }
  }
}
