resource "aws_kinesis_stream" "kinesis_data_stream" {
  name             = "kinesis_data_stream"
  shard_count      = 1
  retention_period = 24

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

  tags = {
    Environment = "dev"
  }
}

resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
  name        = "firehose-delivery-stream"
  destination = "extended_s3"
  
  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.kinesis_data_stream.arn
    role_arn = var.firehose_role_arn
  }

  extended_s3_configuration {
    role_arn   = var.firehose_role_arn
    bucket_arn =var.destination_bucket_arn
    buffering_interval = 30
    buffering_size = 5     
    
    cloudwatch_logging_options {
      enabled = true
      log_group_name = var.cloudwatch_group
      log_stream_name = var.cloudwatch_stream
    }
  }
}
