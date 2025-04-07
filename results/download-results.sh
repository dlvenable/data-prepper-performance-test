#!/bin/bash

PARAMS_FILE="cloudformation/gatling-ec2.params.json"

if [[ ! -f "$PARAMS_FILE" ]]; then
  echo "Error: $PARAMS_FILE not found."
  exit 1
fi

# Use the S3 bucket as specified in the CloudFormation template
RESULTS_BUCKET=$(jq -r '.[] | select(.ParameterKey=="S3BucketName") | .ParameterValue' "$PARAMS_FILE")

if [[ -z "$RESULTS_BUCKET" || "$RESULTS_BUCKET" == "null" ]]; then
  echo "Error: S3BucketName not found in $PARAMS_FILE."
  exit 1
fi

RESULTS_ID=$1

aws s3 sync "s3://$RESULTS_BUCKET/results/$RESULTS_ID" "build/results/$RESULTS_ID"

