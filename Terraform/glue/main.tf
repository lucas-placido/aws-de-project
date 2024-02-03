resource "aws_glue_catalog_database" "aws_glue_catalog_database" {
  name = "ec2-data"
}

resource "aws_glue_crawler" "glue_crawler" {
  database_name = aws_glue_catalog_database.aws_glue_catalog_database.name
  name          = "s3_crawler"
  role          = var.glue_role.arn

  s3_target {
    path = var.bucket
  }
}