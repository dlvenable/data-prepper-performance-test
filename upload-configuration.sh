#!/bin/bash

#
# Generates a Data Prepper setup file and uploads to S3 for use by Data Prepper.
#
# Needs a single argument - the path to the directory to use for your Data Prepper setup.
#
#

DATA_PREPPER_CONFIG_ROOT=$1

PARAMS_FILE="cloudformation/data-prepper-ec2.params.json"

if [[ ! -f "$PARAMS_FILE" ]]; then
  echo "Error: $PARAMS_FILE not found."
  exit 1
fi

TEST_BUCKET=$(jq -r '.[] | select(.ParameterKey=="S3BucketName") | .ParameterValue' "$PARAMS_FILE")

mkdir -p build

tar czf build/data-prepper-setup.tar.gz -C $DATA_PREPPER_CONFIG_ROOT data-prepper

aws s3 cp build/data-prepper-setup.tar.gz s3://$TEST_BUCKET/data-prepper-setup.tar.gz
