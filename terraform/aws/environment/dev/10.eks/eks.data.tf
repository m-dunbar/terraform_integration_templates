# =============================================================================
# terraform_integration_templates :: terraform/aws/environment/dev/10.eks/eks.data.tf
#       :: mdunbar :: 2026 Feb 21 :: MIT License © 2026 Matthew Dunbar ::
# =============================================================================
data "aws_caller_identity" "current" {}

data "aws_vpc" "dev_vpc" {
  filter {
    name   = "tag:Name"
    values = ["dev-us-east-1-vpc"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = data.aws_availability_zones.available.names
}

data "aws_vpc_ipam_pool" "source_pool" {
  filter {
    name   = "tag:Name"
    values = [local.source_ipam_pool_name]
  }
}

# =============================================================================
