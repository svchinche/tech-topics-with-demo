mock_provider "aws" {
  alias = "mock_aws"
  mock_resource "aws_s3_bucket" {
    defaults = {
      arn = "arn:aws:s3::223456789908:test-bucket"
    }
  }
}

variables {
  bucket_prefix = "test"
}

override_data {
  target = module.s3_module.data.aws_caller_identity.current
  values = {
    account_id = "123456789012"
  }
}
override_module {
  target = module.s3_module
  outputs = {
    bucket_name = "overriden_bucket"
  }
}


run "check_s3_bucket_name" {
  providers = {
    aws = aws.mock_aws
  }
  module {
    source = "./s3"
  }
  command = apply
  assert {
    condition     = aws_s3_bucket.bucket.bucket == "test-bucket"
    error_message = "S3 bucket name did not match expected"
  }
}

run "check_s3_bucket_name_from_output" {
  providers = {
    aws = aws.mock_aws
  }
  module {
    source = "./s3"
  }
  command = apply
  assert {
    condition     = output.bucket_name == "overriden_bucket"
    error_message = "S3 bucket name did not match expected"
  }
}

run "check_account_id" {
  providers = {
    aws = aws.mock_aws
  }
  module {
    source = "./s3"
  }
  command = apply
  assert {
    condition     = output.account_id == "123456789012"
    error_message = "account id does not match"
  }
}

run "check_bucket_arn" {
  providers = {
    aws = aws.mock_aws
  }
  module {
    source = "./s3"
  }
  command = apply
  assert {
    condition     = output.bucket_arn == "arn:aws:s3::223456789908:test-bucket"
    error_message = "bucket arn does not match"
  }
}
