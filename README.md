# Data Prepper Performance Test

This project contains support for running Data Prepper performance tests.
It deploys testing support to AWS infrastructure.
It makes use of the existing [Data Prepper performance-test](https://github.com/opensearch-project/data-prepper/tree/main/performance-test) project.

Please note that all commands should be run from the root of this project.

Note, this has only been tested in AWS us-west-2.
To use in other regions may require updates to the AMI Id.

## Run tests

In order to run the tests, you must have set up the Gatling EC2 instances.
Additionally, you still need to maintain the `cloudformation/gatling-ec2.params.json` file because the script will read from there.

Quick run:

```shell
AWS_PROFILE=<profile> AWS_REGION=us-west-2 GATLING_JAVA_ARGS='-Dhost=<ipaddress>' ./run-gatling-tests-ec2.sh
```

You can remove `AWS_PROFILE` if you use default permissions.
You will need to change the `<ipaddress>` to the IP address of your Data Prepper instance.

You can run specific simulations as well:

```shell
AWS_PROFILE=<profile> AWS_REGION=us-west-2 GATLING_JAVA_ARGS='-Dhost=<ipaddress>' SIMULATION_CLASS=org.opensearch.dataprepper.test.performance.<SimulationClass> ./run-gatling-tests-ec2.sh
```

For example, to run the `TargetRpsSimulation` simulation, use:

```shell
AWS_PROFILE=<profile> AWS_REGION=us-west-2 GATLING_JAVA_ARGS='-Dhost=<ipaddress>' SIMULATION_CLASS=org.opensearch.dataprepper.test.performance.TargetRpsSimulation ./run-gatling-tests-ec2.sh
```
