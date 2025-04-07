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

## Update Data Prepper


```
./upload-configuration.sh path/to/directory
```

This directory should have the following structure:

```
path/to/directory/
  data-prepper/
    pipelines/
      ...any pipelines you need...
    config/
      data-prepper-config.yaml
```

After updating, detach the instances from the auto-scaling group so that the ASG deploys new instances.

# Getting results

To download results, use:

```shell
./results/download-results.sh TEST_RUN_ID
```

For example:

```shell
./results/download-results.sh 2025-04-07T13:54:49
```

This will download them into the `build/results` directory. The `TEST_RUN_ID` is part of the path.

After downloading them, you can aggregate the results:

```shell
./results/aggregate-results.sh TEST_RUN_ID
```

This will create a file: `build/results/$TEST_RUN_ID/aggregate-simulation.log`.

### Analyze

```shell
./results/summarize-results.sh TEST_RUN_ID
```


```shell
./results/summarize-results.sh 2025-04-07T13:54:49
```
```
OK:   464764
KO:   474426
```
