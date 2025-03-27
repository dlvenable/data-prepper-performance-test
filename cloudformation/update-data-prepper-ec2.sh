#!/bin/bash

aws cloudformation update-stack --no-cli-pager --stack-name DataPrepperPerformanceTestEc2 \
  --template-body file://cloudformation/data-prepper-ec2.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters file://cloudformation/data-prepper-ec2.params.json
