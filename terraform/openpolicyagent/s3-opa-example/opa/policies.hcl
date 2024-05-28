policy "s3_security_policy_deny" {
  query = "data.terraform.policies.s3_security.deny"
  enforcement_level = "mandatory"
}
