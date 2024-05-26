# Evaluationg OPA in CLI and in Terraform Cloud

AWS S3 Terraform Resource with OPA Policy Enforcement
This project demonstrates the use of Terraform to manage AWS S3 resources, along with Open Policy Agent (OPA) to enforce security policies on the Terraform plan. The policies ensure that no S3 buckets are created with public access, without encryption, or without versioning.

## CLI commands
```sh
terraform plan --out tfplan.binary && terraform show -json tfplan.binary > tfplan.json

opa exec --decision terraform/s3/deny --bundle policy tfplan.json
{
  "result": [
    {
      "path": "tfplan.json",
      "result": [
        "S3 bucket should block all public access",
        "S3 bucket should have 'Product' and 'Name' tags"
      ]
    }
  ]
}
```