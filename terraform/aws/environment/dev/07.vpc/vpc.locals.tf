# =============================================================================
# terraform_integration_templates :: terraform/aws/environment/dev/07.vpc/vpc.locals.tf
#       :: mdunbar :: 2025 Oct 22 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
locals {
  environment = "dev"
  region      = "us-east-1"
  azs         = ["${local.region}a"]  # start with one region for dev, add more if needed

  # Derive subnets from IPAM preview CIDR
  # - partition the initial pool - /24 CIDR split into 4 /26 subnets
  # - then assign first two to private, third to public
  partition       = cidrsubnets(data.aws_vpc_ipam_preview_next_cidr.dev_private_cidr.cidr, 2, 2, 2, 2)
  private_subnets = slice(local.partition, 0, 2)
  public_subnets  = slice(local.partition, 2, 3)
}

# =============================================================================
