# Database Migration Service requires the below IAM Roles to be created before
# replication instances can be created. See the DMS Documentation for
# additional information: https://docs.aws.amazon.com/dms/latest/userguide/CHAP_Security.html#CHAP_Security.APIRole

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

resource "aws_iam_role" "dms-vpc-role" {
  assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
  name               = "dms-vpc-role"
}

resource "aws_iam_role_policy_attachment" "dms-vpc-role-AmazonDMSVPCManagementRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
  role       = aws_iam_role.dms-vpc-role.name
}

// DMS Endpoint Role
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
      {
        Action   = "kinesis:*",
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

resource "aws_iam_role_policy_attachment" "ec2_attatch_role_policy" {
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

resource "aws_iam_role_policy_attachment" "attach_firehose_policies_to_role" {
  role = aws_iam_role.firehose_assume_role.name
  policy_arn = aws_iam_policy.firehose_policies.arn
}

resource "aws_iam_policy" "firehose_policies" {
  name = "firehose_policies"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "cloudwatch:*",
        Effect   = "Allow",
        Resource = "*",
      },
      {
        Action   = "kinesis:*",
        Effect   = "Allow",
        Resource = "*",
      },
      {
        Action   = "kinesis:DescribeStream",  # Add this line
        Effect   = "Allow",
        Resource = "*",  # Modify this line if you want to restrict it to a specific Kinesis stream
      },
      {
        Action   = "s3:*",
        Effect   = "Allow",
        Resource = "*",
      },
    ]
  })
}

// Kinesis Data Stream
resource "aws_iam_role" "kinesis_data_stream_role" {
  name = "kinesis_data_stream_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Sid = "",
        Principal = {
          Service = "kinesis.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_access_to_kinesis" {
  policy_arn = aws_iam_policy.full_access_cloudwatch_policy.arn
  role = aws_iam_role.kinesis_data_stream_role.name
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