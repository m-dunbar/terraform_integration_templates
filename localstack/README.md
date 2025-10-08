# Localstack

LocalStack is an open-source cloud service emulator designed to run a comprehensive suite of AWS services locally. This enables developers to build, test, and iterate on cloud applications without the need to connect to remote cloud providers. It operates in a single container, making it suitable for local development environments and continuous integration (CI) workflows.  ￼

## Key Features

-	Wide AWS Service Emulation: LocalStack supports over 100 AWS services, including Lambda, S3, DynamoDB, SQS, SNS, and more. This extensive coverage allows for comprehensive local testing of cloud applications.  ￼
-	Rapid Development Cycle: With LocalStack, developers can deploy and test full stacks instantly, right on their machine. This eliminates the delays associated with provisioning resources in the cloud, facilitating faster development and debugging.  ￼
-	Enhanced Developer Tools: LocalStack offers features like Lambda hot reloading, which allows developers to update Lambda function code locally and see changes applied instantly without redeploying or restarting services.  ￼
-	Chaos Engineering Capabilities: It includes built-in tools to simulate faults in services like DynamoDB or S3, enabling developers to test the resilience of their applications before deployment.  ￼
-	Web Application Interface: The LocalStack Web App provides a visual interface for managing your LocalStack account and platform features, including resource browsing, stack insights, and CI analytics.  ￼
-	Integration with Development Tools: LocalStack integrates with various development tools and platforms, such as Docker, AWS CDK, and Terraform, to streamline the development and testing process.  ￼

## Use Cases

-	Local Development: Develop and test AWS-based applications on your local machine without incurring cloud costs.
-	Continuous Integration: Integrate LocalStack into CI pipelines to perform automated testing of cloud applications.
-	Onboarding and Training: Provide new team members with a local environment that mirrors production AWS services for training purposes.
-	Resilience Testing: Use chaos engineering features to test how applications behave under failure conditions.

## Requirements

- A container managment service: while it could certinly be deployed in a cloud, with sufficient local memory and VCPUs, a local installation of Docker Desktop, Rancher Desktop or kubernetes provides the greatest utility
- installation of
  - localstack
  - aws cli
  - awslocal
- creation of either support local environment variables or supporting profiles within ~/.aws/config and ~/.aws/credentials

## Deployment

Deployment and manamgent scripts are provided in the top-level directory of the repo.

```
./start_localstack.sh
./stop_localstack.sh
```

These use the included `localstack.deployment.yaml` to provision a local instance.

PLEASE NOTE: that the free tier of localstack does not provide persistance within the simulated local AWS environmnet, nor fully functional modeling of all services.  It does, however, allow for more robust initial testing of terraform HCL against the running localstack.
