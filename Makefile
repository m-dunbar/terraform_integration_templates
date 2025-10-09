# =============================================================================
# terraform_integration_templates :: Makefile :: mdunbar :: 2025 oct 05
# ------------------------------------------------------------------------------
# Terraform Bootstrap Makefile
# Safe by default — `make` prints usage instead of running bootstrap automatically.
# ------------------------------------------------------------------------------
# There are four main prerequite steps to bootstrap a new AWS environment for 
# Terraform best practices:
# 	1. Create an IAM role with policies for Terraform to use.
# 	2. Create a KMS key for encrypting the S3 bucket.
# 	3. Create a DynamoDB table for Terraform state locking.
# 	4. Create an S3 bucket for storing Terraform state files.
# Following which the initial configuration components should all be migrated 
# into centralized s3 backends for tfstate and using state locking to avoid 
# potential collisions if multiple users are working in the same environment. 
# =============================================================================
# Variables
# -------------------------------------
SHELL := /bin/bash

DEV_DIR := environment/dev

AUTH0_DIR := auth0
SAML_DIR  := 01.saml
IAM_DIR   := 02.iam
KMS_DIR 	:= 03.kms
DDB_DIR 	:= 04.dynamodb
S3_DIR  	:= 05.s3

# Run terraform init silently (once)
$(shell cd $(DEV_DIR)/$(IAM_DIR) && terraform init -input=false -no-color >/dev/null 2>&1)

# Capture Terraform output into a global Make variable
ACCOUNT_ID := $(shell cd $(DEV_DIR)/$(IAM_DIR) && terraform output -raw account_id)

# ---------------------------------------------------------------------
# Default target — always first, to prevent accidental apply.
.PHONY: usage
usage:
	@echo "Terraform bootstrap targets:"
	@echo ""
	@echo "  make bootstrap           Run full sequence: IAM → KMS → DDB → S3 → migrate"
	@echo ""
	@echo "  make check-prereqs       Verify Terraform and AWS CLI are installed and configured"
	@echo "  make account_id          Retrive and display AWS account ID variable"
	@echo "  make auth0-bootstrap     Initialize and apply - create Auth0 SAML provider, roles, mappings, and users"
	@echo "  make iam-bootstrap       Initialize and apply - create terraform-provider IAM role + policies"
	@echo "  make kms-bootstrap       Initialize and apply - create terraform KMS key"
	@echo "  make dynamodb-bootstrap  Initialize and apply - Create DynamoDB table for locks"
	@echo "  make s3-bootstrap        Initialize and apply - create S3 bucket for tfstate"
	@echo "  make migrate-backends    Migrate all tfstate backends to S3"
	@echo ""
	@echo "NOTE: No actions are performed by default — use explicit targets."

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
# Primary orchestrator
.PHONY: bootstrap
bootstrap: account_id auth0-bootstrap saml-bootstrap iam-bootstrap kms-bootstrap dynamodb-bootstrap s3-bootstrap migrate-backends

# ---------------------------------------------------------------------
# set AWS account ID variable
.PHONY: account_id
account_id:
	@echo "=== [Account] Setting AWS account ID variable ==="
	@echo "AWS Account ID: $(ACCOUNT_ID)"

# ---------------------------------------------------------------------
# set up Auth0 SAML provider and roles
.PHONY: auth0-bootstrap
auth0-bootstrap:
	@echo "=== [Auth0] Initializing Terraform ==="
	@echo "=== [Auth0] Creating Auth0 SAML provider, roles, mappings, and users ==="
	cd $(AUTH0_DIR) && terraform init && \
	terraform plan
# 	terraform apply -auto-approve

# ---------------------------------------------------------------------
# SAML setup
.PHONY: saml-bootstrap
saml-bootstrap:
	@echo "=== [AWS] Initializing SAML Terraform ==="
	@echo "=== [AWS] Creating AWS SAML provider ==="
	cd $(DEV_DIR)/$(SAML_DIR) && terraform init -input=false && \
	terraform plan
# 	terraform apply -auto-approve


# ---------------------------------------------------------------------
# IAM setup
.PHONY: iam-bootstrap
iam-bootstrap:
	@echo "=== [AWS] Initializing IAM Terraform ==="
	@echo "=== [AWS] Creating IAM role(s) and policies ==="
	cd $(DEV_DIR)/$(IAM_DIR) && terraform init -input=false && \
	terraform plan
# 	terraform apply -auto-approve

# ---------------------------------------------------------------------
# KMS setup
.PHONY: kms-bootstrap
kms-bootstrap:
	@echo "=== [KMS] Initializing Terraform ==="
	cd $(DEV_DIR)/$(KMS_DIR) && terraform init -input=false
	@echo "=== [KMS] Creating KMS key and access policy ==="
	# terraform apply -target=aws_kms_key.tfstate_key
	# terraform apply -target=aws_kms_key_policy.provisioner_access
	cd $(KMS_DIR) && terraform import aws_kms_key.tfstate_key arn:aws:kms:us-east-1:$(ACCOUNT_ID):key/KEY_ID || true

# ---------------------------------------------------------------------
# DynamoDB setup
.PHONY: dynamodb-bootstrap
dynamodb-bootstrap:
	@echo "=== [DynamoDB] Creating lock table ==="
	cd $(DEV_DIR)/$(DDB_DIR) && terraform init -input=false
	# terraform apply -target=aws_dynamodb_table.terraform_locks
	cd $(DEV_DIR)/$(DDB_DIR) && terraform import aws_dynamodb_table.terraform_locks terraform-locks || true

# ---------------------------------------------------------------------
# S3 setup
.PHONY: s3-bootstrap
s3-bootstrap:
	@echo "=== [S3] Initializing Terraform ==="
	cd $(DEV_DIR)/$(S3_DIR) && terraform init -input=false
	@echo "=== [S3] Creating S3 bucket for tfstate (manual or CLI) ==="
	# aws s3api create-bucket --bucket terraform-tfstate --region us-east-1
	cd $(S3_DIR) && terraform import aws_s3_bucket.tfstate terraform-tfstate || true
	@echo "=== [S3] Applying KMS encryption and versioning ==="
	cd $(S3_DIR) && terraform apply -target=aws_s3_bucket.tfstate -auto-approve

# ---------------------------------------------------------------------
# Backend migration
.PHONY: migrate-backends
migrate-backends:
	@echo "=== [S3] Migrating backend to remote ==="
	cd $(S3_DIR) && mv backend.tf.noop backend.tf && terraform init -migrate-state -input=false
	@echo "=== [DynamoDB] Migrating backend to remote ==="
	cd $(DDB_DIR) && mv backend.tf.noop backend.tf && terraform init -migrate-state -input=false
	@echo "=== [KMS] Migrating backend to remote ==="
	cd $(KMS_DIR) && mv backend.tf.noop backend.tf && terraform init -migrate-state -input=false
	@echo "=== [IAM] Migrating backend to remote ==="
	cd $(IAM_DIR) && mv backend.tf.noop backend.tf && terraform init -migrate-state -input=false