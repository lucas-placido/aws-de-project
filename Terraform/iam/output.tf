output "s3-role" {
    value = aws_iam_role.s3_full_access_role.arn
}

output "ec2_role" {
  value = aws_iam_instance_profile.ec2_profile.name
}