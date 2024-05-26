resource "aws_s3_bucket" "s3-bucket" {
  bucket = "my-s3-bucket"
  acl = "public-read"
#  tags = {
#    Name    = "s3-bucket"
#    Product = "s3-product"
#  }
#  server_side_encryption_configuration {
#    rule {
#      apply_server_side_encryption_by_default {
#        sse_algorithm = "AES256"
#      }
#    }
#  }
  versioning {
    enabled = false
  }
  lifecycle_rule {
    enabled = true
    abort_incomplete_multipart_upload_days = 1
  }
}

resource "aws_s3_bucket_public_access_block" "s3_public" {
  bucket = aws_s3_bucket.s3-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}