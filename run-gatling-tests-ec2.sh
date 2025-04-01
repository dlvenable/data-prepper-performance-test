#!/bin/bash

#
# Runs a Gatling simulation on the Gatling EC2 instances.
#

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

# Use StaticRequestSimulation by default because it is fast
SIMULATION_CLASS=${SIMULATION_CLASS:-"org.opensearch.dataprepper.test.performance.StaticRequestSimulation"}

# These arguments let us configure Gatling via Java properties.
GATLING_JAVA_ARGS=${GATLING_JAVA_ARGS:-""}

# Check for required environment variables
if [[ -z "$RESULTS_BUCKET" ]]; then
  echo "Error: RESULTS_BUCKET is not set. Export it and try again."
  exit 1
fi

# Generate a test run Id that will be in the S3 key.
test_run=`date +"%Y-%m-%dT%H:%M:%S"`

# Get instance IDs from the Auto Scaling Group
INSTANCE_IDS=$(aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names DataPrepperGatlingTest \
  --query "AutoScalingGroups[0].Instances[*].InstanceId" \
  --output text | tr '\t' ',')

if [[ -z "$INSTANCE_IDS" ]]; then
  echo "Error: No running instances found in the Auto Scaling Group."
  exit 1
fi

# Use SSM to run Gatling on all EC2 instances
aws ssm send-command \
  --no-cli-pager \
  --document-name "AWS-RunShellScript" \
  --targets "Key=InstanceIds,Values=${INSTANCE_IDS}" \
  --parameters "commands=[
    'java -Xms6g -Xmx6g $GATLING_JAVA_ARGS -jar /home/ec2-user/opensearch-data-prepper-performance-test.jar -rf /home/ec2-user/results -s $SIMULATION_CLASS',
    'aws s3 cp /home/ec2-user/results/ s3://$RESULTS_BUCKET/results/$test_run/ --recursive',
    'rm -rf /home/ec2-user/results/*'
  ]" \
  --comment "Run Gatling simulation" \
  --output text
