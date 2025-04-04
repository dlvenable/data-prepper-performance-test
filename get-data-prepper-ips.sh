#!/bin/bash

# Set your Auto Scaling Group name
ASG_NAME="DataPrepperPerformanceTestEc2"

# Get all instance IDs from the ASG
INSTANCE_IDS=$(aws autoscaling describe-auto-scaling-groups \
    --auto-scaling-group-names "$ASG_NAME" \
    --query "AutoScalingGroups[0].Instances[*].InstanceId" \
    --output text)

# Check if any instances are found
if [ -z "$INSTANCE_IDS" ]; then
    echo "No instances found in ASG: $ASG_NAME"
    exit 1
fi

# Get private IPs of instances and format as comma-delimited list
PRIVATE_IPS=$(aws ec2 describe-instances \
    --instance-ids $INSTANCE_IDS \
    --query "Reservations[*].Instances[*].PrivateIpAddress" \
    --output text | tr '\n' ',' | sed 's/,$//')

echo "$PRIVATE_IPS"
