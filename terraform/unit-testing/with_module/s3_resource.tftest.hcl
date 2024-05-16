mock_provider "aws" {
  alias = "mock_aws"
}

variables {
  bucket_prefix = "test"
}

run "valid_string_concat" {
  module {
    source = "./modules/s3"
  }
  providers = {
    aws = aws.mock_aws
  }
  command = apply
  assert {
    condition     = aws_s3_bucket.bucket.bucket == "test-bucket"
    error_message = "S3 bucket name did not match expected"
  }
}

run "valid_string_concat_output" {
  module {
    source = "./modules/s3"
  }
  providers = {
    aws = aws.mock_aws
  }
  command = apply
  assert {
    condition     = output.bucket_name == "test-bucket"
    error_message = "S3 bucket name did not match expected"
  }
}
