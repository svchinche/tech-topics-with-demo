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