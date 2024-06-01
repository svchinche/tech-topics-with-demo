#!/bin/bash

## variables
DIR_NAME=$(dirname $(realpath $0))
PROJECT_ROOT_DIR="$DIR_NAME/.."
TERRAFORM_INIT_DIR=".terraform"
TERRAFORM_BINARY_FILE="tfplan.binary"
TERRAFORM_JSON_FILE="tfplan.json"

##  go to root directory

cd $PROJECT_ROOT_DIR

if [ -d "$TERRAFORM_INIT_DIR" ]; then
    echo "Terraform has already been initialized in this directory."
else
    # If .terraform directory doesn't exist, initialize Terraform
    echo "Initializing Terraform..."
    cd "$TF_DIR" || exit
    terraform init
fi

if [ -f "$TERRAFORM_BINARY_FILE" ]; then
   echo "tfplan binary file exist - $TERRAFORM_BINARY_FILE"
else
   echo "override" | terraform plan --input=false --out $TERRAFORM_BINARY_FILE
   [[ $? -ne 0 ]] && echo  "enable to run plan command" && exit 1
fi

if [ -f "$TERRAFORM_JSON_FILE" ]; then
   echo "plan file is present - $TERRAFORM_JSON_FILE"
else
    ## this temparary fix to generate plan file which is compatible for opa command and for TFC
    terraform show -json $TERRAFORM_BINARY_FILE | jq '{plan: .}' > $TERRAFORM_JSON_FILE
    [[ $? -ne 0 ]] && echo  "enable to run plan command" && exit 1
fi