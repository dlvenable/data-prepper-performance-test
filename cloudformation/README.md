# CloudFormation

This directory has CloudFormation tools to deploy the testing framework.

## Gatling setup

You can deploy EC2 instances to support running Gatling.

Create a file at `cloudformation/gatling-ec2.params.json` to provide CloudFormation parameters.

```json
[
  {
    "ParameterKey": "S3BucketName",
    "ParameterValue": "<bucketName>"
  },
  {
    "ParameterKey": "VpcId",
    "ParameterValue": "<vpcId>"
  },
  {
    "ParameterKey": "SubnetIds",
    "ParameterValue": "<subnet1Id>,<subnetId2>"
  },
  {
    "ParameterKey": "KeyPairName",
    "ParameterValue": "<keyPairName>"
  }
]
```

You must supply the parameters.

Then deploy the CloudFormation template:

```shell
AWS_PROFILE=<profile> AWS_REGION=us-west-2 ./cloudformation/create-gatling-ec2.sh
```

This will create an EC2 auto-scaling group with instances ready to use for Gatling.
This creates 4 instances. You can change this as needed.


If you make changes, you can also update the stack:

```shell
AWS_PROFILE=<profile> AWS_REGION=us-west-2 ./cloudformation/update-gatling-ec2.sh
```
