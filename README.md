# Terraform Integration Templates

[Terraform](terraform.io), by Hashicorp, is very likely the most widely-adopted, open-source Infrastructure-as-Code (IaC) platform in use, world-wide, at this time (2025).

This repo provides a set of sample templates, implementing a fully-functional, integrated application stack incorporating centralized, SOC2-compliant, Single Sign-on (SSO) authentication to an AWS account, and a web-based application stack.

WHEN COMPLETE, THIS SET OF TEMPLATES WILL PROVIDE:

## Docker

Docker is an open-source plaform for the development, demployment and managment of applcations via containerization.  This sample lverages docker to create the images deployed to a kubernetes cluster supporting the web application stack.

## Auth0

Auth0 is a SOC2-compliant, identity-as-a-service (IDaaS) platform that provides authentication and authorization services for applications. It allows developers to securely manage user identities without building a custom identity solution from scratch.

This example implements

- a centrally-managed, source-of-authority (SOA) identity, authentication, authorization platform Identity Provider (IdP)
- SAML-based AWS CLI authentication
- terraform-based tenant, user, and role management, with the ability to support multiple environments for full lifecycle management

## Amazon Web Services (AWS)

Currently (again as of Q3 2025) is one of, if not _the_, leading Cloud Services providers, with approximately 1/3 of the global marketshare.

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

### Elastic Kubernetes Servic (EKS)

Amazon's implementation of Kubernetes (k8s) as a managed service

### Application Load Balancer (ALB)

providing load balancing services fronting the EKS deployment

### Route53 

providing Domain Name Service (DNS) to be able to reach the sample application

### Relational Database Services (RDS)

providing backend database services for the sample web application

### Elasticache

using ValKey for site indexing

## Wordpress

Wordpess powers approximately 60% of all websites using a Content Management System (CMS), and a little over 40% of all websites.  It's ubiquity, as well as it's use of the above services, make it an excellent sample application for these templates.

## Localstack prototyping

While somewhat limited in scope, Localstack is a local AWS emulator, allowing for more rigorous local testing of terraform prior to an actual rollout witihn an AWS account.

<hr>

© 2025 Matthew Dunbar  
(See LICENSE for details.)