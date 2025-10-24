# =============================================================================
# terraform_integration_templates :: Makefile :: mdunbar :: 2025 oct 05
# ------------------------------------------------------------------------------
# Terraform Bootstrap Makefile
# Safe by default — `make` prints usage instead of running bootstrap automatically.
# ------------------------------------------------------------------------------
# There are four main prerequisite steps to bootstrap a new AWS environment for 
# Terraform best practices:
# 	1. Create an IAM role with policies for Terraform to use.
# 	2. Create a KMS key for encrypting the S3 bucket.
# 	3. Create a DynamoDB table for Terraform state locking.
# 	4. Create an S3 bucket for storing Terraform state files.
# Following which the initial configuration components should all be migrated 
# into centralized s3 backends for tfstate and using state locking to avoid 
# potential collisions if multiple users are working in the same environment.

# There is also an optional prior step, if you're working with a federated identity
# provider such as Auth0:
# 	0. Create the Auth0 SAML provider, roles, mappings, and users
# Using this approach allows implementation of a best-practice approach of a
#   Role-based Access Control (RBAC) model for AWS access
# =============================================================================
# Variables
# -------------------------------------
SHELL := /bin/bash

TF_ENV  := terraform/aws/environment
DEV_DIR := $(TF_ENV)/dev

AUTH0_DIR := terraform/auth0
SAML_DIR  := 01.saml
IAM_DIR   := 02.iam
KMS_DIR 	:= 03.kms
DDB_DIR 	:= 04.dynamodb
S3_DIR  	:= 05.s3
IPAM_DIR  := 06.ipam
VPC_DIR   := 07.vpc

# --------------------------------------
# Get the active AWS account ID
ACCOUNT_ID := $(shell aws sts get-caller-identity --query Account --output text 2>/dev/null)
ACCOUNT_ALIAS := $(shell aws iam list-account-aliases --query 'AccountAliases[0]' --output text 2>/dev/null || aws sts get-caller-identity --query Account --output text)

ifeq ($(ACCOUNT_ID),)
$(error AWS CLI is not configured properly. Please run 'aws configure' to set up your credentials.)
endif

# Supporting Functions
# -------------------------------------
define apply # $(1): directory
	cd $(1) && \
	if [ ! -d .terraform ]; then \
		terraform init; \
	fi && \
	terraform apply -auto-approve
endef

define migrate # $(1): directory, $(2): backend filename prefix
	cd $(1) && \
	cp $(2).backend.tf.noop $(2).backend.tf && \
	terraform init -migrate-state
endef

define plan # $(1): directory, $(2): plan options, $(3): backend filename prefix
	cd $(1) && \
	if [ ! -d .terraform ]; then \
		terraform init; \
	fi && \
	if [ "$(strip $(3))" ]; then \
		cp $(3).backend.tf.noop $(3).backend.tf; \
	fi && \
	terraform plan $(2)
endef


# ---------------------------------------------------------------------
# Default target — always first, to prevent accidental apply.
.PHONY: usage
usage:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Preflight checks:"
	@echo ""
	@echo "  make check-prereqs       Verify Terraform and AWS CLI are installed and configured"
	@echo "  make account-info        Retrieve and display AWS account information for the currently account profile in use"
	@echo ""
	@echo "Terraform plan targets (no changes made):"
	@echo ""
	@echo "  make plan                Plan all components"
	@echo ""
	@echo "  make plan-auth0          Plan Auth0 component"
	@echo "  make plan-saml           Plan SAML component"
	@echo "  make plan-iam            Plan IAM component"
	@echo "  make plan-kms            Plan KMS component"
	@echo "  make plan-dynamodb       Plan DynamoDB component"
	@echo "  make plan-s3             Plan S3 component"
	@echo "  make plan-ipam           Plan IPAM component"
	@echo "  make plan-vpc            Plan VPC component"
	@echo ""
	@echo "Terraform bootstrap targets:"
	@echo ""
	@echo "  make bootstrap           Run full sequence: Auth0 → SAML → IAM → KMS → DDB → S3 → migrate"
	@echo ""
	@echo "  make auth0-bootstrap     Initialize and apply - create Auth0 SAML provider, roles, mappings, and users"
	@echo "  make saml-bootstrap      Initialize and apply - create AWS SAML provider"
	@echo "  make iam-bootstrap       Initialize and apply - create terraform-provider IAM role + policies"
	@echo "  make kms-bootstrap       Initialize and apply - create terraform KMS key"
	@echo "  make dynamodb-bootstrap  Initialize and apply - Create DynamoDB table for locks"
	@echo "  make s3-bootstrap        Initialize and apply - create S3 bucket for tfstate"
	@echo "  make migrate-backends    Migrate all tfstate backends to S3"
	@echo ""
	@echo "Post-bootstrap targets:"
	@echo ""
	@echo "  make ipam-apply      	   Initialize and apply - provision IPAM map"
	@echo "  make vpc-apply       	   Initialize and apply - provision VPC and subnets"

	@echo ""
	@echo "NOTE: No actions are performed by default — use explicit recipe targets."

# ---------------------------------------------------------------------
# Check prerequisites
.PHONY: check-prereqs
check-prereqs:
	@echo "=== [Check] Verifying prerequisites ==="
	@command -v terraform >/dev/null 2>&1 || { echo >&2 "Terraform is required but it's not installed. Aborting."; exit 1; }
	@command -v aws >/dev/null 2>&1 || { echo >&2 "AWS CLI is required but it's not installed. Aborting."; exit 1; }
	@aws sts get-caller-identity >/dev/null 2>&1 || { echo >&2 "AWS CLI is not configured properly. Aborting."; exit 1; }
	@echo "All prerequisites are met."

# ---------------------------------------------------------------------
# set AWS account ID variable
.PHONY: account-info
account-info:
	@if [ "$(ACCOUNT_ALIAS)" != "None" ] && [ -n "$(ACCOUNT_ALIAS)" ]; then \
		echo "=== You are currently working with AWS Account Alias: $(ACCOUNT_ALIAS) ($(ACCOUNT_ID)) ==="; \
	else \
		echo "=== You are currently working with AWS Account ID: $(ACCOUNT_ID) ==="; \
	fi

# ---------------------------------------------------------------------
# Plan all components
.PHONY: plan
plan: account-info plan-auth0 plan-saml plan-iam plan-kms plan-dynamodb plan-s3 plan-ipam plan-vpc
	@echo
	@echo "=== [Plan] Completed for all components ==="

# ---------------------------------------------------------------------
# Plan Auth0
.PHONY: plan-auth0
plan-auth0:
	@echo -e "\nPlan Auth0"
	$(call plan,$(AUTH0_DIR))

# ---------------------------------------------------------------------
# Plan SAML
.PHONY: plan-saml
plan-saml:
	@echo -e "\nPlan SAML"
	$(call plan,$(DEV_DIR)/$(SAML_DIR))

# ---------------------------------------------------------------------
# Plan IAM
.PHONY: plan-iam
plan-iam:
	@echo -e "\nPlan IAM"
	$(call plan,$(DEV_DIR)/$(IAM_DIR))

# ---------------------------------------------------------------------
# Plan KMS
.PHONY: plan-kms
plan-kms:
	@echo -e "\nPlan KMS"
	$(call plan,$(DEV_DIR)/$(KMS_DIR))

# ---------------------------------------------------------------------
# Plan DynamoDB
.PHONY: plan-dynamodb
plan-dynamodb:
	@echo -e "\nPlan DynamoDB"
	$(call plan,$(DEV_DIR)/$(DDB_DIR),-var "bootstrap_plan=true")

# ---------------------------------------------------------------------
# Plan S3
.PHONY: plan-s3
plan-s3:
	@echo -e "\nPlan S3"
	$(call plan,$(DEV_DIR)/$(S3_DIR))

# ---------------------------------------------------------------------
# Plan IPAM
.PHONY: plan-ipam
plan-ipam:
	@echo -e "\nPlan IPAM"
	$(call plan,$(DEV_DIR)/$(IPAM_DIR),,ipam)

# ---------------------------------------------------------------------
# Plan VPC
.PHONY: plan-vpc
plan-vpc:
	@echo -e "\nPlan VPC"
	$(call plan,$(DEV_DIR)/$(VPC_DIR),,vpc)

# ---------------------------------------------------------------------

# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# Primary orchestrator
.PHONY: bootstrap
bootstrap: account-info auth0-bootstrap saml-bootstrap iam-bootstrap kms-bootstrap dynamodb-bootstrap s3-bootstrap migrate-backends

# ---------------------------------------------------------------------
# set up Auth0 SAML provider and roles
.PHONY: auth0-bootstrap
auth0-bootstrap:
	@echo "=== [Auth0] Creating Auth0 SAML provider, roles, mappings, and users ==="
	$(call apply,$(AUTH0_DIR))

# ---------------------------------------------------------------------
# SAML setup
.PHONY: saml-bootstrap
saml-bootstrap:
	@echo "=== [AWS] Creating AWS SAML provider ==="
	$(call apply,$(DEV_DIR)/$(SAML_DIR))

# ---------------------------------------------------------------------
# IAM setup
.PHONY: iam-bootstrap
iam-bootstrap:
	@echo "=== [AWS] Creating IAM role(s) and policies ==="
	$(call apply,$(DEV_DIR)/$(IAM_DIR))

# ---------------------------------------------------------------------
# KMS setup
.PHONY: kms-bootstrap
kms-bootstrap:
	@echo "=== [KMS] Creating KMS key and access policy ==="
	$(call apply,$(DEV_DIR)/$(KMS_DIR))

# ---------------------------------------------------------------------
# DynamoDB setup
.PHONY: dynamodb-bootstrap
dynamodb-bootstrap:
	@echo "=== [DynamoDB] Creating lock table ==="
	$(call apply,$(DEV_DIR)/$(DDB_DIR))

# ---------------------------------------------------------------------
# S3 setup
.PHONY: s3-bootstrap
s3-bootstrap:
	@echo "=== [S3] Creating S3 bucket for tfstate (manual or CLI) ==="
	$(call apply,$(DEV_DIR)/$(S3_DIR))

# ---------------------------------------------------------------------
# Backend migration
.PHONY: migrate-backends
migrate-backends:
	@echo "=== [S3] Migrating backend to remote ==="
	$(call migrate,$(DEV_DIR)/$(S3_DIR),s3)
	@echo "=== [DynamoDB] Migrating backend to remote ==="
	$(call migrate,$(DEV_DIR)/$(DDB_DIR),dynamodb)
	@echo "=== [KMS] Migrating backend to remote ==="
	$(call migrate,$(DEV_DIR)/$(KMS_DIR),kms)
	@echo "=== [IAM] Migrating backend to remote ==="
	$(call migrate,$(DEV_DIR)/$(IAM_DIR),iam)
	@echo "=== [SAML] Migrating backend to remote ==="
	$(call migrate,$(DEV_DIR)/$(SAML_DIR),saml)

# ---------------------------------------------------------------------
# Post-bootstrap: IPAM setup
.PHONY: post-bootstrap
post-bootstrap: ipam-apply vpc-apply
	@echo "=== [Post-Bootstrap] for all components ==="

# ---------------------------------------------------------------------
# IPAM setup
.PHONY: ipam-apply
ipam-apply:
	@echo "=== [IPAM] Defining CIDR Pools ==="
	$(call apply,$(DEV_DIR)/$(IPAM_DIR))

# ---------------------------------------------------------------------
# VPC setup
.PHONY: vpc-apply
vpc-apply:
	@echo "=== [VPC] Defining VPC and subnets ==="
	$(call apply,$(DEV_DIR)/$(VPC_DIR))
