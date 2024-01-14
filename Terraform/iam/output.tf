output "s3-role" {
    value = aws_iam_role.s3_full_access_role.arn
}

output "ec2_role" {
  value = aws_iam_instance_profile.ec2_profile.name
}

output "firehose_role" {
  value = aws_iam_role.firehose_assume_role
}

output "kinesis_data_stream_role" {
  value = aws_iam_role.kinesis_data_stream_role
}