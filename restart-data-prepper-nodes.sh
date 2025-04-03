#!/bin/bash

ASG_NAME="DataPrepperPerformanceTestEc2"

# Get all instance IDs from the ASG
INSTANCE_IDS=$(aws autoscaling describe-auto-scaling-groups \
    --no-cli-pager \
    --auto-scaling-group-names "$ASG_NAME" \
    --query "AutoScalingGroups[0].Instances[*].InstanceId" \
    --output text)

# Check if any instances are found
if [ -z "$INSTANCE_IDS" ]; then
    echo "No instances found in ASG: $ASG_NAME"
    exit 1
fi

echo "Instances in ASG ($ASG_NAME): $INSTANCE_IDS"

# Loop through each instance and detach it
for INSTANCE_ID in $INSTANCE_IDS; do
    echo "Detaching instance: $INSTANCE_ID"
    aws autoscaling detach-instances \
        --no-cli-pager \
        --instance-ids "$INSTANCE_ID" \
        --auto-scaling-group-name "$ASG_NAME"
done

# Give time for instances to detach
sleep 10

# Terminate instances
for INSTANCE_ID in $INSTANCE_IDS; do
    echo "Terminating instance: $INSTANCE_ID"
    aws ec2 terminate-instances --no-cli-pager --instance-ids "$INSTANCE_ID"
done

echo "All instances detached and terminated."
