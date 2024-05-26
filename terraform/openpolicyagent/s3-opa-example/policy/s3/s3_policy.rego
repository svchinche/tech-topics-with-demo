package terraform.s3

import input.tfplan as tfplan

allowed_acls = ["private"]
#allowed_sse_algorithms = ["aws:kms", "AES256"]
allowed_sse_algorithms = ["aws:kms"]

s3_buckets[r] {
    r := tfplan.resource_changes[_]
    r.type == "aws_s3_bucket"
}

array_contains(arr, elem) {
  arr[_] = elem
}

# Rule to restrict S3 bucket ACLs
deny[reason] {
    r := s3_buckets[_]
    not array_contains(allowed_acls, r.change.after.acl)
    reason := sprintf(
        "%s: ACL %q is not allowed",
        [r.address, r.change.after.acl]
    )
}

# Rule to require server-side encryption
deny[reason] {
    r := s3_buckets[_]
    count(r.change.after.server_side_encryption_configuration) == 0
    reason := sprintf(
        "%s: requires server-side encryption with expected sse_algorithm to be one of %v",
        [r.address, allowed_sse_algorithms]
    )
}

# Rule to enforce specific SSE algorithms
deny[reason] {
    r := s3_buckets[_]
    sse_configuration := r.change.after.server_side_encryption_configuration[_]
    apply_sse_by_default := sse_configuration.rule[_].apply_server_side_encryption_by_default[_]
    not array_contains(allowed_sse_algorithms, apply_sse_by_default.sse_algorithm)
    reason := sprintf(
        "%s: expected sse_algorithm to be one of %v",
        [r.address, allowed_sse_algorithms]
    )
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
