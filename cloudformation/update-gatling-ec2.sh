#!/bin/bash

aws cloudformation update-stack --no-cli-pager --stack-name DataPrepperGatlingPerformanceTest \
  --template-body file://cloudformation/gatling-ec2.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameters file://cloudformation/gatling-ec2.params.json
