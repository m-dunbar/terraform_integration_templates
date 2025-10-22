# Makefile

Terraform provides a robust Infrastructure-as-Code (IaC) framework for implementing and managing resources and complete application stacks (within AWS and beyond).

However, there are certain initial configuration items that present a bit of a chicken-and-egg conundrum.

Terraform best practices include the use of a centralized location for state management, rather than the default local state management on an Engineer's individual workstation.  There are, however, certain resources that must be defined within AWS in order to support such a backend.

## Prerequisites

For this example stack, there are a small number of prerequisites:

- an AWS account (obviously)
- authentication credentials - best practice is to create a specific _role_ for terraform provisioning (in more advanced environments this may be two or more roles, once CI/CD is in place -- one for plan, and another for apply, for example to allow developers to perform `plan` against the production environment when initially testing new terraform code, but to only allow `apply` for production to be performed by way of CI/CD automation)
- a terraform backend - for which S3 is the most common choice
- a dynamodb table - to provide centralized state locking during `terraform plan` and `terraform apply` actions
- a dedicated kms key - to provide encryption at rest for tfstate and terraform locks data

## Chicken versus Egg

The source of our conundrum here is that if we follow best practices, we should be using terraform to define many the very prerequisites we just listed.  We don't want to have to manually create those resource, but we can't implement a backend configuration until the initial s3 state bucket is created.  Nor can we configure central state locking as part of that backend until we have a dynamodb table.

The solution is to write terraform to create these prerequisites, apply the initial 'bootstrap' for those essentials, then implement the supporting backend configs and port the resulting state files to respective sub-folders within s3.

In order to do so in the correct order, writing supporting scripting is also the obvious choice.  And, nearly all workstations have `make`, making a Makefile an excellent means to provide a framework without also having to write additional supporting logic to be able to selectively or completely create these prerequisites and to implement the centralized backend, maintaining the tfstate of those supporting resources.

See the section in the main README that explains naming conventions and the `.noop` suffix for further details about the underlying mechanics, if interested.

## Performing the initial bootstrap

Initial bootstrapping is accomplished leveraging `make`, alleviating the need to navigate to each respective resource directory manually to perform `terraform plan` or `terraform apply`.  Given that all actions when working with IaC should be deliberate, the default recipe within Makefile provides usage.

```
%# make
Usage: make <target>

Preflight checks:

  make check-prereqs       Verify Terraform and AWS CLI are installed and configured
  make account-info        Retrieve and display AWS account information for the currently account profile in use

Terraform plan targets (no changes made):

  make plan                Plan all components

  make plan-auth0          Plan Auth0 component
  make plan-saml           Plan SAML component
  make plan-iam            Plan IAM component
  make plan-kms            Plan KMS component
  make plan-dynamodb       Plan DynamoDB component
  make plan-s3             Plan S3 component

Terraform bootstrap targets:

  make bootstrap           Run full sequence: Auth0 → SAML → IAM → KMS → DDB → S3 → migrate

  make auth0-bootstrap     Initialize and apply - create Auth0 SAML provider, roles, mappings, and users
  make saml-bootstrap      Initialize and apply - create AWS SAML provider
  make iam-bootstrap       Initialize and apply - create terraform-provider IAM role + policies
  make kms-bootstrap       Initialize and apply - create terraform KMS key
  make dynamodb-bootstrap  Initialize and apply - Create DynamoDB table for locks
  make s3-bootstrap        Initialize and apply - create S3 bucket for tfstate
  make migrate-backends    Migrate all tfstate backends to S3

NOTE: No actions are performed by default — use explicit recipe targets.
```

Sanity-checking for initial requirements is provided via the recipe `check-prereqs`.  An additional safety measure is offered via the recipe `account-info`

Implementation is modular, allowing individual plan or apply for sets of resources.

---

© 2025 Matthew Dunbar  
(See LICENSE for details.)
