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

AUTH0_DIR 		  := terraform/auth0
OIDC_SAML_DIR   := 01.auth_providers
IAM_DIR   		  := 02.iam
KMS_DIR 			  := 03.kms
DDB_DIR 			  := 04.dynamodb
S3_DIR  			  := 05.s3
IPAM_DIR  		  := 06.ipam
VPC_DIR     	  := 07.vpc
RDS_DIR   		  := 08.rds
ELASTICACHE_DIR := 09.elasticache
EKS_DIR         := 10.eks

# --------------------------------------
# Get the active AWS account ID
ACCOUNT_ID := $(shell aws sts get-caller-identity --query Account --output text 2>/dev/null)
ACCOUNT_ALIAS := $(shell aws iam list-account-aliases --query 'AccountAliases[0]' --output text 2>/dev/null || aws sts get-caller-identity --query Account --output text)

ifeq ($(ACCOUNT_ID),)
$(error AWS CLI is not configured properly. Please run 'aws configure' to set up your credentials.)
endif

# Supporting Functions
# -------------------------------------
define activate # $(1): directory, $(2) tf file
	cd $(1) && \
	if [ -e $(2).tf.noop ]; then \
		cp $(2).tf.noop $(2).tf; \
	fi
endef

define apply # $(1): directory
	cd $(1) && \
	if [ ! -d .terraform ]; then \
		terraform init; \
	fi && \
	terraform apply -auto-approve
endef

define deactivate # $(1): directory, $(2) tf file
	cd $(1) && \
	if [ -e $(2).tf ]; then \
		mv $(2).tf $(2).tf.noop; \
	fi
endef

define destroy # $(1): directory
	cd $(1) && \
	terraform destroy
endef

define migrate # $(1): directory, $(2): backend filename prefix
	cd $(1) && \
	cp $(2).backend.tf.noop $(2).backend.tf && \
	terraform init -migrate-state
endef

define plan # $(1): directory, $(2): plan options, $(3): backend filename prefix
	cd $(1) && \
	if [ "$(strip $(3))" ]; then \
		cp $(3).backend.tf.noop $(3).backend.tf; \
	fi && \
	if [ ! -d .terraform ]; then \
		terraform init -upgrade; \
	fi && \
	terraform plan $(2)
endef
# TODO: add logic to 'plan' to support updates in the event init has already been run previously

# Recipe Targets
# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# Default target — always first, to prevent accidental apply.
.PHONY: usage
usage:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Preflight checks:"
	@echo ""
	@echo "  make check-prereqs        Verify Terraform and AWS CLI are installed and configured"
	@echo "  make account-info         Retrieve and display AWS account information for the currently account profile in use"
	@echo ""
	@echo "Terraform plan targets (no changes made):"
	@echo ""
	@echo "  make plan                 Plan all components"
	@echo ""
	@echo "  make plan-auth0           Plan Auth0 component"
	@echo "  make plan-providers       Plan OIDC/SAML components"
	@echo "  make plan-iam             Plan IAM component"
	@echo "  make plan-kms             Plan KMS component"
	@echo "  make plan-dynamodb        Plan DynamoDB component"
	@echo "  make plan-s3              Plan S3 component"
	@echo "  make plan-ipam            Plan IPAM component"
	@echo "  make plan-vpc             Plan VPC component"
	@echo "  make plan-rds             Plan RDS component"
	@echo "  make plan-elasticache     Plan ElastiCache component"
	@echo "  make plan-eks             Plan EKS component"
	@echo ""
	@echo "Terraform bootstrap targets:"
	@echo ""
	@echo "  make bootstrap            Run full sequence: Auth0 → SAML → IAM → KMS → DDB → S3 → migrate"
	@echo ""
	@echo "  make auth0-bootstrap      Initialize and apply - create Auth0 SAML provider, roles, mappings, and users"
	@echo "  make provider-bootstrap   Initialize and apply - create AWS SAML provider"
	@echo "  make iam-bootstrap        Initialize and apply - create terraform-provider IAM role + policies"
	@echo "  make kms-bootstrap        Initialize and apply - create terraform KMS key"
	@echo "  make dynamodb-bootstrap   Initialize and apply - Create DynamoDB table for locks"
	@echo "  make s3-bootstrap         Initialize and apply - create S3 bucket for tfstate"
	@echo "  make migrate-backends     Migrate all tfstate backends to S3"
	@echo ""
	@echo "Post-bootstrap targets:"
	@echo ""
	@echo "  make ipam-apply      	    Initialize and apply - provision IPAM map"
	@echo "  make vpc-apply       	    Initialize and apply - provision VPC and subnets"
	@echo ""
	@echo "Select RDS Configuration:"
	@echo ""
	@echo "  make aurora-active        Select Aurora RDS configuration"
	@echo "  make aurora-inactive      Unselect Aurora RDS configuration"
	@echo "  make mariadb-active       Select Maria DB configuration"
	@echo "  make mariadb-inactive     Unselect Maria DB configuration"
	@echo ""
	@echo "Post-bootstrap targets:"
	@echo ""
	@echo "Post-bootstrap targets:"
	@echo ""
	@echo "  make rds-apply       	    Initialize and apply - provision RDS cluster"
	@echo "  make elasticache-apply    Initialize and apply - provision ElastiCache cluster"
	@echo "  make eks-apply       	   Initialize and apply - provision EKS cluster"
	@echo ""
	@echo "Teardown:"
	@echo ""
	@echo "  make rds-destroy          De-provision and destroy RDS cluster"
	@echo "  make elasticache-destroy  De-provision and destroy ElastiCache cluster"
	@echo "  make eks-destroy          De-provision and destroy EKS cluster"
	@echo ""
	@echo "  make cleanup              De-provision and destroy all terraform-managed resources"
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
plan: account-info plan-auth0 plan-providers plan-iam plan-kms plan-dynamodb plan-s3 plan-ipam plan-vpc plan-rds plan-elasticache plan-eks
	@echo
	@echo "=== [Plan] Completed for all components ==="

# ---------------------------------------------------------------------
# Plan Auth0
.PHONY: plan-auth0
plan-auth0:
	@echo -e "\nPlan Auth0"
	@$(call plan,$(AUTH0_DIR))

# ---------------------------------------------------------------------
# Plan OIDC/SAML
.PHONY: plan-providers
plan-providers:
	@echo -e "\nPlan OIDC/SAML Providers"
	@$(call plan,$(DEV_DIR)/$(OIDC_SAML_DIR))

# ---------------------------------------------------------------------
# Plan IAM
.PHONY: plan-iam
plan-iam:
	@echo -e "\nPlan IAM"
	@$(call plan,$(DEV_DIR)/$(IAM_DIR))

# ---------------------------------------------------------------------
# Plan KMS
.PHONY: plan-kms
plan-kms:
	@echo -e "\nPlan KMS"
	@$(call plan,$(DEV_DIR)/$(KMS_DIR))

# ---------------------------------------------------------------------
# Plan DynamoDB
.PHONY: plan-dynamodb
plan-dynamodb:
	@echo -e "\nPlan DynamoDB"
	@if [ -e $(DEV_DIR)/$(DDB_DIR)/.terraform ]; then \
		$(call plan,$(DEV_DIR)/$(DDB_DIR)); \
	else \
		$(call plan,$(DEV_DIR)/$(DDB_DIR),-var "bootstrap_plan=true"); \
	fi

# ---------------------------------------------------------------------
# Plan S3
.PHONY: plan-s3
plan-s3:
	@echo -e "\nPlan S3"
	@$(call plan,$(DEV_DIR)/$(S3_DIR))

# ---------------------------------------------------------------------
# Plan IPAM
.PHONY: plan-ipam
plan-ipam:
	@echo -e "\nPlan IPAM"
	@$(call plan,$(DEV_DIR)/$(IPAM_DIR),,ipam)

# ---------------------------------------------------------------------
# Plan VPC
.PHONY: plan-vpc
plan-vpc:
	@echo -e "\nPlan VPC"
	@$(call plan,$(DEV_DIR)/$(VPC_DIR),,vpc)

# ---------------------------------------------------------------------
# Plan RDS
.PHONY: plan-rds
plan-rds:
	@echo -e "\nPlan RDS"
	@$(call plan,$(DEV_DIR)/$(RDS_DIR),,rds)

# ---------------------------------------------------------------------
# Plan Elasticache
.PHONY: plan-elasticache
plan-elasticache:
	@echo -e "\nPlan ElastiCache"
	@$(call plan,$(DEV_DIR)/$(ELASTICACHE_DIR),,elasticache)

# ---------------------------------------------------------------------
# Plan EKS
.PHONY: plan-eks
plan-eks:
	@echo -e "\nPlan EKS"
	@$(call plan,$(DEV_DIR)/$(EKS_DIR),,eks)

# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# Primary orchestrator
.PHONY: bootstrap
bootstrap: account-info auth0-bootstrap provider-bootstrap iam-bootstrap kms-bootstrap dynamodb-bootstrap s3-bootstrap migrate-backends

# ---------------------------------------------------------------------
# set up Auth0 SAML provider and roles
.PHONY: auth0-bootstrap
auth0-bootstrap:
	@echo "=== [Auth0] Creating Auth0 SAML provider, roles, mappings, and users ==="
	@$(call apply,$(AUTH0_DIR))

# ---------------------------------------------------------------------
# SAML setup
.PHONY: provider-bootstrap
provider-bootstrap:
	@echo "=== [AWS] Creating AWS OIDC/SAML providers ==="
	@$(call apply,$(DEV_DIR)/$(OIDC_SAML_DIR))

# ---------------------------------------------------------------------
# IAM setup
.PHONY: iam-bootstrap
iam-bootstrap:
	@echo "=== [AWS] Creating IAM role(s) and policies ==="
	@$(call apply,$(DEV_DIR)/$(IAM_DIR))

# ---------------------------------------------------------------------
# KMS setup
.PHONY: kms-bootstrap
kms-bootstrap:
	@echo "=== [KMS] Creating KMS key and access policy ==="
	@$(call apply,$(DEV_DIR)/$(KMS_DIR))

# ---------------------------------------------------------------------
# DynamoDB setup
.PHONY: dynamodb-bootstrap
dynamodb-bootstrap:
	@echo "=== [DynamoDB] Creating lock table ==="
	@$(call apply,$(DEV_DIR)/$(DDB_DIR))

# ---------------------------------------------------------------------
# S3 setup
.PHONY: s3-bootstrap
s3-bootstrap:
	@echo "=== [S3] Creating S3 bucket for tfstate (manual or CLI) ==="
	@$(call apply,$(DEV_DIR)/$(S3_DIR))

# ---------------------------------------------------------------------
# Backend migration
.PHONY: migrate-backends
migrate-backends:
	@echo "=== [S3] Migrating backend to remote ==="
	@$(call migrate,$(DEV_DIR)/$(S3_DIR),s3)
	@echo "=== [DynamoDB] Migrating backend to remote ==="
	@$(call migrate,$(DEV_DIR)/$(DDB_DIR),dynamodb)
	@echo "=== [KMS] Migrating backend to remote ==="
	@$(call migrate,$(DEV_DIR)/$(KMS_DIR),kms)
	@echo "=== [IAM] Migrating backend to remote ==="
	@$(call migrate,$(DEV_DIR)/$(IAM_DIR),iam)
	@echo "=== [OIDC/SAML Providers] Migrating backend to remote ==="
	@$(call migrate,$(DEV_DIR)/$(OIDC_SAML_DIR),saml)

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
	@$(call apply,$(DEV_DIR)/$(IPAM_DIR))

# ---------------------------------------------------------------------
# VPC setup
.PHONY: vpc-apply
vpc-apply:
	@echo "=== [VPC] Defining VPC and subnets ==="
	@$(call apply,$(DEV_DIR)/$(VPC_DIR))

# ---------------------------------------------------------------------
# RDS config - aurora active
.PHONY: aurora-active
aurora-active:
	@echo "=== [RDS] Enabling Aurora Cluster Configuration ==="
	@$(call activate,$(DEV_DIR)/$(RDS_DIR),main.aurora)

# ---------------------------------------------------------------------
# RDS setup - aurora inactive
.PHONY: aurora-inactive
aurora-inactive:
	@echo "=== [RDS] Disabling Aurora Cluster Configuration ==="
	@$(call deactivate,$(DEV_DIR)/$(RDS_DIR),main.aurora)

# ---------------------------------------------------------------------
# RDS setup - mariadb active
.PHONY: mariadb-active
mariadb-active:
	@echo "=== [RDS] Enabling Maria DB Configuration ==="
	@$(call activate,$(DEV_DIR)/$(RDS_DIR),main.maria_db)

# ---------------------------------------------------------------------
# RDS setup - mariadb inactive
.PHONY: mariadb-inactive
mariadb-inactive:
	@echo "=== [RDS] Disabling Maria DB Configuration ==="
	@$(call deactivate,$(DEV_DIR)/$(RDS_DIR),main.maria_db)

# ---------------------------------------------------------------------
# RDS setup
.PHONY: rds-apply
rds-apply:
	@echo "=== [RDS] Creating RDS cluster ==="
	@$(call apply,$(DEV_DIR)/$(RDS_DIR))

# ---------------------------------------------------------------------
# Elasticache setup
.PHONY: elasticache-apply
elasticache-apply:
	@echo "=== [Elasticache] Creating Valkey cluster ==="
	@$(call apply,$(DEV_DIR)/$(ELASTICACHE_DIR))

# ---------------------------------------------------------------------
# EKS setup
.PHONY: eks-apply
eks-apply:
	@echo "=== [EKS] Creating EKS cluster ==="
	@$(call apply,$(DEV_DIR)/$(EKS_DIR))

# ---------------------------------------------------------------------
# ---------------------------------------------------------------------
# Primary orchestrator
.PHONY: cleanup
cleanup: account-info rds-destroy elasticache-destroy eks-destroy
	@echo "=== [Cleanup] Completed for all components ==="

# ---------------------------------------------------------------------
# RDS destroy with confirmation
.PHONY: rds-destroy
rds-destroy:
	@echo "=== [RDS] WARNING: This will destroy the RDS cluster in $(DEV_DIR)/$(RDS_DIR) ==="
	@read -p "Are you sure you want to continue? Type 'yes' to confirm: " CONFIRM && \
	if [ "$$CONFIRM" = "yes" ]; then \
		$(call destroy,$(DEV_DIR)/$(RDS_DIR)); \
	else \
		echo "RDS cluster preserved."; \
	fi

# ---------------------------------------------------------------------
# Elasticache destroy with confirmation
.PHONY: elasticache-destroy
elasticache-destroy:
	@echo "=== [Elasticache] WARNING: This will destroy the ElastiCache cluster in $(DEV_DIR)/$(ELASTICACHE_DIR) ==="
	@read -p "Are you sure you want to continue? Type 'yes' to confirm: " CONFIRM && \
	if [ "$$CONFIRM" = "yes" ]; then \
		$(call destroy,$(DEV_DIR)/$(ELASTICACHE_DIR)); \
	else \
		echo "Valkey cluster preserved."; \
	fi

# ---------------------------------------------------------------------
# EKS destroy with confirmation
.PHONY: eks-destroy
eks-destroy:
	@echo "=== [EKS] WARNING: This will destroy the EKS cluster in $(DEV_DIR)/$(EKS_DIR) ==="
	@read -p "Are you sure you want to continue? Type 'yes' to confirm: " CONFIRM && \
	if [ "$$CONFIRM" = "yes" ]; then \
		$(call destroy,$(DEV_DIR)/$(EKS_DIR)); \
	else \
		echo "EKS cluster preserved."; \
	fi
