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

## Configure Terraform Cloud + Module

Add organization details in providers.tf file

```sh
terraform {
  required_version = "=1.7.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
 cloud {
   organization = "ccoms"
   workspaces {
     name = "my_workspace"
   }
 }
}

provider "aws" {
  region = "us-east-1"
}
```
Setup Terraform Cloud.
1. Create Organization, if not available
2. Create Workspace, if not created.
3. Configure env variables as show below
4. Run terraform init on CLI 
5. Run terraform plan
6. Check output in CLI and in terraform Cloud

### Configure env variables
<p align="center"><img width="800" height="400" src=".images/tfc_env.png"></p>

### Run terraform init on CLI
```sh
terraform init -upgrade
```

### Run terraform plan from CLI
<p align="center"><img width="800" height="400" src=".images/tfcli_plan.png"></p>

### Check output in CLI and in terraform Cloud
<p align="center"><img width="800" height="400" src=".images/tfc_plan.png"></p>