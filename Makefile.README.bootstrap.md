# Makefile

Terraform provides a robust Infrastructure-as-Code (IaC) framework for implementing and managing resources and complete application stacks (within AWS and beyond).

However, there are certain initial configuration items that present a bit of a chicken-and-egg conundrum.

Terraform best practices include the use of a centralized location for state management, rather than the default local state managment on an Engineer's individual workstation.  There are, however, certain resources that must be defined within AWS in order to support such a backend.

## Prerequites

For this example stack, there are a small number of prerequisites:

- an AWS account (obviously)
- authentication credentials - best practice is to create a specific _role_ for terraform provisioning (in more advanced environments this may be two or more roles, once CI/CD is in place -- one for plan, and another for apply, for example to allow developers to perform `plan` against the production environment when initially testing new terraform code, but to only allow `apply` for production to be performed by way of CI/CD automation)
- a terraform backend - for which S3 is the most common choice
- a dynamodb table - to provide centralized state locking during `terraform plan` and `terraform apply` actions
- a dedicated kms key - to provide encryption at rest for tfstate and terrafom locks data

## Chicken versus Egg

The source of our conundrum here is that if we follow best practices, we should be using terraform to define many the very prerequisites we just listed.  We don't want to have to manually create those resource, but we can't implement a backend configuration until the initial s3 state bucket is created.  Nor can we configure central state locking as part of that backend until we have a dynamodb table.

The solution is to write terraform to create these prerequisites, apply the initial 'bootstrap' for those essentials, then implement the supporting backend configs and port the resulting statefiles to respective subfolders within s3.

In order to do so in the correct order, writing supporting scripting is also the obvious choice.  And, nearly all workstations have `make`, making a Makefile an excellent means to provide a framework without also having to write additional supporting logic to be able to selectively or completely create these prereqs and to implement the centralized backend, maintaining the tfstate of those supporting resources.

See the section in the main README that explains naming conventions and the `.noop` suffix for further details about the underlying mechanics, if interested.

## Performing the initial bootstrap

[instructions to be added here once Makefile structure reahes a stable state]

<hr>

© 2025 Matthew Dunbar  
(See LICENSE for details.)