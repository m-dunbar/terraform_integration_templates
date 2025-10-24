# =============================================================================
# terraform_integration_templates :: terraform/aws/environment/dev/07.vpc/vpc.data.tf
#       :: mdunbar :: 2025 Oct 23 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
# AWS Account info
data "aws_caller_identity" "current" {}

data "aws_vpc_ipam_pool" "dev_private_cidr" {
  filter {
    name   = "description"
    values = ["Dev private subnet pool"]
  }

  filter {
    name   = "address-family"
    values = ["ipv4"]
  }
}

output "vpc_dev_private_ipam_pool_id" {
  value = data.aws_vpc_ipam_pool.dev_private_cidr.id
}

data "aws_vpc_ipam_preview_next_cidr" "dev_private_cidr" {
  ipam_pool_id   = data.aws_vpc_ipam_pool.dev_private_cidr.id
  netmask_length = 24
}

output "vpc_dev_private_cidr_preview" {
  value = data.aws_vpc_ipam_preview_next_cidr.dev_private_cidr
}

# =============================================================================
