provider "aws" {
    region = "eu-central-1"
}

variable "bucket_prefix" {
  type = string
  default = "test"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_prefix}-bucket"
}

data "aws_caller_identity" "current" {}

output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.bucket.arn
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}