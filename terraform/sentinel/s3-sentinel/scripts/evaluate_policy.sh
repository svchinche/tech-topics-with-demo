#!/bin/bash

## variables
DIR_NAME=$(dirname $(realpath $0))
PROJECT_ROOT_DIR="$DIR_NAME/.."
TERRAFORM_JSON_FILE="tfplan.json"
DECISION="terraform/policies/s3_security/deny "

if [ ! -f $TERRAFORM_JSON_FILE ]; then
   echo "tfplan file does not exist, exiting here. Run create_plan_json_file.sh file first"
   exit 1
fi


opa exec --decision $DECISION --bundle policy $TERRAFORM_JSON_FILE | jq --raw-output '.result[].result[]'