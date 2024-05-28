resource "aws_s3_bucket" "s3_bucket" {
  bucket = "my-s3-bucket-suyog"
  tags = {
    company    = "ccoms"
    business   = "ccoms"
  }
}

resource "aws_s3_bucket_versioning" "s3_version" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket = aws_s3_bucket.s3_bucket.id
  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_server_side_encryption_configuration" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#resource "aws_s3_bucket_acl" "s3_acl" {
#  bucket = aws_s3_bucket.s3_bucket.id
#  acl    = "public-read"
#  depends_on = [ 
#    aws_s3_bucket_ownership_controls.s3_bucket_ownership_controls 
#  ]
#}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_ownership_controls" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
  depends_on = [ 
    aws_s3_bucket_public_access_block.s3_bucket_public_access_block 
  ]
}