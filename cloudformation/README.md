# CloudFormation

This directory has CloudFormation tools to deploy the testing framework.

## Gatling setup

These steps create an EC2 auto-scaling group (ASG) with EC2 instances setup and ready to run the Data Prepper performance-test Gatling tests.

### Build the Data Prepper performance test uberjar

Run the following commands from a local clone of the Data Prepper project:

```
./gradlew :performance-test:assemble
aws s3 cp performance-test/build/libs/opensearch-data-prepper-performance-test-2.12.0-SNAPSHOT.jar s3://<S3BucketName>/opensearch-data-prepper-performance-test.jar
```

Be sure the check the Data Prepper version on the source side.
You should use the exact name provided in the destination because the CloudFormation templates do not expect version numbers.

### Configuring your environment

The rest of the steps should be run from this project.

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

### Creating the CloudFormation stack

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

### Edit your Auto-Scaling Group

Using the AWS Console, you can set the desired instances to any number between 1-50.
Each instance in the ASG will run the tests in parallel. 
