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

output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}