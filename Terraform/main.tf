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
  profile                  = "cloudGuru"
}

module "databases" {
  source = "./databases"
}

module "iam" {
  source = "./iam"
}

module "datatransfer" {
  source = "./datatransfer"
  aws_security_group_id = module.databases.vpc_security_group_ids
  rds_password = module.databases.rds_password
  rds_endpoint = module.databases.rds_endpoint
  bucket_name = module.buckets.bucket-name
  s3-role = module.iam.s3-role
}

module "buckets" {
  source = "./buckets"
}

module "vpc" {
  source = "./vpc"  
  # ips = [module.datatransfer.dmsIP[0]]
}

module "ec2" {
  source = "./ec2"
  security_group = module.vpc.security_group
  ec2_role = module.iam.ec2_role
}

module "cloudwatch" {
  source = "./cloudwatch"
}

module "kinesis" {
  source = "./kinesis"
  firehose_role = module.iam.firehose_role
  destination_bucket_arn = module.buckets.firehose_bucket_arn
  cloudwatch_group = module.cloudwatch.cloudwatch_group
  cloudwatch_stream = module.cloudwatch.cloudwatch_stream
}