# Database Migration Service requires the below IAM Roles to be created before
# replication instances can be created. See the DMS Documentation for
# additional information: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.html#CHAP_Security.APIRole
#  * dms-vpc-role
#  * dms-cloudwatch-logs-role
#  * dms-access-for-endpoint

# //////// DMS //////////
data "aws_iam_policy_document" "dms_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["dms.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "dms-access-for-endpoint" {
  assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
  name               = "dms-access-for-endpoint"
}

resource "aws_iam_role" "dms-vpc-role" {
  assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
  name               = "dms-vpc-role"
}

resource "aws_iam_role_policy_attachment" "dms-vpc-role-AmazonDMSVPCManagementRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
  role       = aws_iam_role.dms-vpc-role.name
}

resource "aws_iam_role" "s3_full_access_role" {
  name = "s3_full_access_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Sid    = "",
        Principal = {
          Service = "dms.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_policy" "s3_full_access_policy" {
  name        = "s3_full_access_policy"
  description = "Policy for full access to Amazon S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "s3:*",
        Effect   = "Allow",
        Resource = "*",
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_full_access_attachment" {
  policy_arn = aws_iam_policy.s3_full_access_policy.arn
  role       = aws_iam_role.s3_full_access_role.name
}

# //////// EC2 //////////
resource "aws_iam_policy" "ec2_full_access_firehose" {
  name = "ec2_full_access_firehose"
  description = "Allow ec2 to access firehose and iam"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "firehose:*",
        Effect   = "Allow",
        Resource = "*",
      },
      {
        Action   = "iam:*",
        Effect   = "Allow",
        Resource = "*",
      },
    ]
  })
}

resource "aws_iam_role" "ec2_assume_firehose_role" {
  name = "ec2_assume_firehose_role"

 assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Sid    = "",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  
  tags = {
    description = "Role to give access for ec2 get credentials"
  }
}

resource "aws_iam_role_policy_attachment" "ec2-attatch-role-policy" {
  policy_arn = aws_iam_policy.ec2_full_access_firehose.arn
  role = aws_iam_role.ec2_assume_firehose_role.name
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2_assume_firehose_role.name
}

# //////// Firehose //////////
resource "aws_iam_role" "firehose_assume_role" {
  name = "firehose_assume_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Sid = "",
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "firehose_access_to_s3" {
  role = aws_iam_role.firehose_assume_role.name
  policy_arn = aws_iam_policy.s3_full_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "firehose_access_to_cloudwatch" {
  role = aws_iam_role.firehose_assume_role.name
  policy_arn = aws_iam_policy.full_access_cloudwatch_policy.arn
}

resource "aws_iam_policy" "full_access_cloudwatch_policy" {
  name = "full_access_cloudwatch_policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "cloudwatch:*",
        Effect   = "Allow",
        Resource = "*",
      },      
    ]
  })
}

