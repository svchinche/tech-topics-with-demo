package terraform.s3

deny[msg] {
  some i
  input.resource_changes[i].type == "aws_s3_bucket"
  input.resource_changes[i].change.after.server_side_encryption_configuration == null
  msg = "S3 bucket encryption is not enabled"
}

deny[msg] {
  some i
  input.resource_changes[i].type == "aws_s3_bucket"
  input.resource_changes[i].change.after.acl != "private"
  msg = "S3 bucket ACL is not private"
}

deny[msg] {
  some i
  input.resource_changes[i].type == "aws_s3_bucket"
  not input.resource_changes[i].change.after.tags["Product"]
  not input.resource_changes[i].change.after.tags["Name"]
  msg = "S3 bucket should have 'Product' and 'Name' tags"
}

deny[msg] {
  some i
  input.resource_changes[i].type == "aws_s3_bucket"
  not input.resource_changes[i].change.after.public_access_block.block_public_acls
  not input.resource_changes[i].change.after.public_access_block.block_public_policy
  not input.resource_changes[i].change.after.public_access_block.ignore_public_acls
  not input.resource_changes[i].change.after.public_access_block.restrict_public_buckets
  msg = "S3 bucket should block all public access"
}
