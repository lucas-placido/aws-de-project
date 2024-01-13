output "s3-role" {
    value = aws_iam_role.s3_full_access_role.arn
}