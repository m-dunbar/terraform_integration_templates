# Terraform Integration Templates

[Terraform](terraform.io), by Hashicorp, is one of the most widely-adopted, open-source Infrastructure-as-Code (IaC) platforms in use world-wide.<sup><a href="#fn1" id="ref1">1</a></sup>

This repo provides a set of sample templates, implementing a fully-functional, integrated application stack incorporating centralized, SOC2-compliant, Single Sign-on (SSO) authentication to an AWS account, and a web-based application stack.

## File Organization

While adhering somewhat to sample 'idiomatic' terraform file organization, logical organization of the files within the this template repo avoids the use of either a single mono-repo where all terraform resides in a single logical space, which would by extension would also result in a single monolithic tfstate file.  While a monolithic single directory approach, and the declaration of a single monolithic 'main.tf' works for very small implementations, and provides a clear structure for sample code, in real-world environments, this is far less practical.

A single mono-repo and resulting single tfstate file are, in practice, brittle.  This provides no logical segmentation, either for resource organization and definition, nor provides any compartmentalization of tfstate into smaller, more limited and easily protected tfstate files.  Smaller, segmented tfstate files limits the 'blast radius' of any potential changes, in the event of some interruption of the apply process, or of any format errors being introduced.  Since tfstate is JSON, so much as a single misplaced flow character can completely break tfstate.  Logical segmentation -- by resource type, or by project stack, or other manageable, rational chunk -- is therefore a recommended best practice, and is a common approach in many (if not most) Enterprise environments.

Similarly, separation of resources into smaller files, using a clear, easy to comprehend logical naming structure dramatically improves maintainability, making it much easier to find particular resources rapidly, and again minimizing the scope of a given file.  This means in the event of an error being introduced, it can be identified and addressed more quickly.

### Directory Structure

The directory structure follows a logical organization common for terraform and related components.  Individual components are separated by tool first, then by logical organization for each tool, as appropriate. 

#### Top-level

The top level of the repo contains .gitignore, LICENSE file, a Makefile, README files, and directories for the particular tools implemented for the template stack:

```
terraform_integration_templates  
├─ .gitignore  
├─ LICENSE  
├─ Makefile  
├─ Makefile.README.bootstrap.md  
├─ README.md  
├─ docker  
├─ localstack  
└─ terraform  
```

#### Sub-folders

Sub-folder structures provide logical organization for the related files, as well as, in the case of terraform, providing logical compartmentalization into multiple tfstates.

Example:

```
terraform_integration_templates
└── terraform
    ├── auth0
    ├── aws
    │   └── environment
    │       └── dev
    │           ├── 01.saml
    │           ├── 02.iam
    │           ├── 03.kms
    │           ├── 04.dynamodb
    │           ├── 05.s3
    │           ├── 06.ipam
    │           ├── 07.vpc
    │           ├── 08.rds
    │           ├── 09.elasticache
    │           ├── 10.eks
    │           ├── 11.acm
    │           ├── 12.alb
    │           ├── 13.route53
    │           └── 14.waf
    └── modules
        └── auth0
            ├── application
            ├── password_reset
            ├── role
            ├── saml_action
            └── user
```

This contains all of the relevant terraform, divided by supported provider (auth0 or aws), with a subfolder for custom modules.  The aws subfolder is, in turn, organized by environments, and then by resource type, organized in the order of dependency creation.  

Segmented by resource in this manner, `terraform plan` and `terraform apply` are performed within the level of each of these sub-folders, each with their own backend configuration with corresponding key paths.  This compartmentalizes tfstate, limiting their respective scopes.  Changes within each of these subdirectories will not affect any other tfstates.  This decreases the size and complexity of individual tfstates, allowing for faster `plan` and `apply` runs, while also decreasing the scope of individual changes being performed during each run.  In the event of an error, this also limits the scope of potential impact.

### File Naming Convention

within the subdirectory structure, terraform filenames follow the structure:

```
<resource_category_prefix>.<resource_subtype>.[specific_resource_division].<file_type_suffix_string>
```

**resource_category_prefix** - corresponds to the broad service-related category, also reflecting the directory structure.  The prefix provides clear information about the category, location within the broader tree, and prevents any accidental overwrites in the event a file is accidentally moved to an incorrect location. (Ex. 's3')

**resource_subtype** - corresponds to the terraform resource subtype.  This could be something like 'backend', 'data', 'locals', 'provider', 'variables', or an actual provider-level resource type, such as 'bucket', 'key', 'role', 'table', or other similar object. (Ex. 'bucket')

**specific_resource_division** - an optional designator for a specific resource. (Ex. 'tf-integration-template-terraform-state-us-east-1')

**file_type_suffix_string** - one or more suffixes defining file type.  In many instances, suffixes determine whether terraform automatically picks up that file. (Ex. 'tf')

Fully realized example:

```
s3.bucket.tf-integration-template-terraform-state-us-east-1.tf
```

#### A Note about the '.noop' suffix

Since terraform identifies which files to process when performing `plan` or `apply`, it can be useful to use an alternate suffix for defining files that for whatever reason, should not be applied at a given time.  `.noop` is a suffix which provides a clear meaning for this purpose, indicating both to terraform and to the humans working with it that the contents of a file with such a suffix will not be processed.

For purposes of initial deployment, before minimum base requirements for a best-practice terraform backend implementation have been met, the `.noop` suffix has been applied for backend configurations in order to define the eventual best-practice backend, but to allow us to `apply` the baseline resources.  After those resources are in place, the suffix can be removed, terraform can be reinitialized, and the backend configuration and migration of tfstate to an S3 backend can be completed.

Initial baseline deployment, including reconfiguration and migration of all backend configs is implemented via the included `Makefile`, as documented in the top-level README.Makefile.md.


## 

WHEN COMPLETE, THIS SET OF TEMPLATES WILL PROVIDE:

## Docker [placeholder]

Docker is an open-source platform for the development, deployment and management of applications via containerization.  This sample leverages docker to create the images deployed to a kubernetes cluster supporting the web application stack.

## Auth0

Auth0 is a SOC2-compliant, identity-as-a-service (IDaaS) platform that provides authentication and authorization services for applications. It allows developers to securely manage user identities without building a custom identity solution from scratch.

This example implements

- a centrally-managed, source-of-authority (SOA) identity, authentication, authorization platform Identity Provider (IdP)
- SAML-based AWS CLI authentication
- terraform-based tenant, user, and role management, with the ability to support multiple environments for full lifecycle management

## Amazon Web Services (AWS)

Currently (again as of Q3 2025) is one of, if not _the_, leading Cloud Services providers, with approximately 1/3 of the global market share.

This repo provides a terraform module-based, fully-integrated application stack implementing

### IP Address Management (IPAM)-based CIDR Allocation

### AWS-native security implementing

#### - Security Assertion Markup Language (SAML) Service provider (SP)

enabling use of the Auth0 IdP to provide single sign-on (SSO) authentication access

#### - Identity and Acccess Management (IAM)

implementing role-based access control (RBAC) and both AWS and customer-managed policy-based resource access

#### - Key Management Service (KMS)

for cryptographic key management

#### - Security Groups (SGs)

for granular, network rule-based resource access

#### - Amazon Certificate Management (ACM)

for transport layer security (TLS) certificate management

### Dynamodb

supporting terraform locks files to prevent resource management collisions when applying terraform updates

### Simple Storage Servce (S3)

Amazon's Object store, providing storage for terraform state files, and module-based management of S3 buckets for cloud-based storage.  This includes policy-based storage access and lifecycle management.

### Virtual Private Cloud (VPC)

logically-isolated virtual networks, leveraging both private and public subnets, across multiple Regions and Availability Zones (AZs)

### Relational Database Services (RDS)

providing backend database services for the sample web application

### Elasticache

using ValKey for site indexing

### Elastic Kubernetes Service (EKS)

Amazon's implementation of Kubernetes (k8s) as a managed service

### Application Load Balancer (ALB)

providing load balancing services fronting the EKS deployment

### Route53 

providing Domain Name Service (DNS) to be able to reach the sample application

### Web Application Firewall (WAF)

leveraging AWS-curated rules to provide DDOS and other protections for the ALB 

## WordPress [placeholder]

As of October 2025, WordPress powers approximately 60% of all websites using a Content Management System (CMS), and a little over 40% of all websites.<sup><a href="#fn2" id="ref2">2</a></sup>  WordPress's ubiquity, as well as it's use of the above services, make it an excellent sample application for these templates.

## Localstack prototyping

While somewhat limited in scope, Localstack is a local AWS emulator, allowing for more rigorous local testing of terraform prior to an actual rollout within an AWS account.

<hr>

Sources:

<a id="fn1"></a>1. Firefly.ai. *The State of Infrastructure as Code in 2025*. Firefly.ai, 2025, p. 5, [https://www.firefly.ai/asset-state-of-iac-report-2025](https://www.firefly.ai/asset-state-of-iac-report-2025). [↩︎](#ref1)

<a id="fn2"></a>2. Clorici, Pavel. “How Many Websites Use WordPress in October 2025? WordPress Statistics.” *WPZoom*, 17 Apr. 2025, [https://www.wpzoom.com/blog/wordpress-statistics/](https://www.wpzoom.com/blog/wordpress-statistics/). [↩︎](#ref2)

<hr>

© 2025 Matthew Dunbar  
(See LICENSE for details.)