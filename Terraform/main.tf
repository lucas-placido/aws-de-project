terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  shared_credentials_files = ["C:/Users/lucas/.aws/credentials"]
  profile                  = "default"
}

module "databases" {
  source = "./databases"
  security_group_allow_tls_id = module.vpc.allow_tls_security_group_id
}

module "iam" {
  source = "./iam"
}

module "dms" {
  source = "./dms"  
  rds_password = module.databases.rds_password
  rds_endpoint = module.databases.rds_endpoint
  bucket_name = module.buckets.bucket-name
  s3-role = module.iam.s3-role
  security_group_allow_tls_id = module.vpc.allow_tls_security_group_id
  dms_role = module.iam.dms_role.name
}

module "buckets" {
  source = "./buckets"
}

module "vpc" {
  source = "./vpc"  
  # ips = [module.dms.dmsIP[0]]
}

module "ec2" {
  source = "./ec2"
  security_group = module.vpc.allow_tls_security_group_name
  ec2_role = module.iam.ec2_role
  kinesis_data_stream = module.kinesis.aws_kinesis_kinesis_data_stream.name
}

module "cloudwatch" {
  source = "./cloudwatch"
}

module "kinesis" {
  source = "./kinesis"
  kinesis_data_stream_role = module.iam.kinesis_data_stream_role
  firehose_role_arn = module.iam.firehose_role.arn
  destination_bucket_arn = module.buckets.firehose_bucket_arn
  cloudwatch_group = module.cloudwatch.cloudwatch_group
  cloudwatch_stream = module.cloudwatch.cloudwatch_stream
}