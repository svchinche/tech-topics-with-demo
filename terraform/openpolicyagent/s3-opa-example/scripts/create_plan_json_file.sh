#!/bin/bash

terraform plan --out tfplan.binary

## this temparary fix to generate plan file which is compatible for opa command and for TFC
terraform show -json tfplan.binary | jq '{plan: .}' > tfplan.json