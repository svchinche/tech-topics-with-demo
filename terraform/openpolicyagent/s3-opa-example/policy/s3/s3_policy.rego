package terraform.policies.s3_security

import input.plan as tfplan

deny[reason] {
  r = tfplan.resource_changes[_]
  r.type == "aws_s3_bucket_server_side_encryption_configuration"
  rule = r.change.after.rule[_]
  apply_server = rule.apply_server_side_encryption_by_default[_]
  apply_server.sse_algorithm != "aws:kms"
  reason := sprintf("%-20s :: S3 bucket must be encrypted using KMS", [r.address])
}

deny[reason] {
  r = tfplan.resource_changes[_]
  r.type == "aws_s3_bucket"
  not r.change.after.tags["Product"]
  not r.change.after.tags["Name"]
  reason := sprintf("%-20s :: S3 bucket should have Product and Name tags", [r.address])
}

deny[reason] {
  r = tfplan.resource_changes[_]
  r.type == "aws_s3_bucket_public_access_block"
  r.change.after.block_public_acls != "true"
  r.change.after.block_public_policy != "true"
  r.change.after.ignore_public_acls != "true"
  r.change.after.restrict_public_buckets != "true"
  reason := sprintf("%-20s :: S3 buckets all public should be blocked", [r.address])
}

deny[reason] {
  r = tfplan.resource_changes[_]
  r.type == "aws_s3_bucket_acl"
  r.change.after.acl != "private"
  reason := sprintf("%-20s :: S3 buckets must not be public", [r.address])
}

deny[reason] {
  r = tfplan.resource_changes[_]
  r.type == "aws_s3_bucket_versioning"
  conf = r.change.after.versioning_configuration[_]
  conf.status != "Enabled"
  reason := sprintf("%-20s :: S3 buckets versioning must be Enabled", [r.address])
}