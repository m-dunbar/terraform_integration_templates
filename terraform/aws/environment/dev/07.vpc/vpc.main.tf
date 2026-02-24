# =============================================================================
# terraform_integration_templates :: terraform/aws/environment/dev/07.vpc/main.tf
#       :: mdunbar :: 2025 Oct 22 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
module "vpc_dev" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.5.0"

  name                 = "${local.environment}-${local.region}"
  cidr                 = data.aws_vpc_ipam_preview_next_cidr.dev_private_cidr.cidr
  azs                  = local.azs
  private_subnets      = local.private_subnets
  public_subnets       = local.public_subnets

  private_subnet_names = [
    for az in local.azs : "${local.environment}-${az}-private"
  ]
  public_subnet_names = [
    for az in local.azs : "${local.environment}-${az}-public"
  ]

  default_network_acl_name      = "${local.environment}-${local.region}-nacl"
  default_route_table_name      = "${local.environment}-${local.region}-rtb"
  default_security_group_name   = "${local.environment}-${local.region}-sg"

  enable_nat_gateway     = true   # required for EKS nodes to pull container images 
                                  # -- and updates, and for cluster management if endpoint_public_access is false
  single_nat_gateway     = true   # cheaper, fine for dev
  one_nat_gateway_per_az = false  # default anyway

  enable_dns_hostnames = true
  enable_dns_support   = true


  private_subnet_tags_per_az = {
    for az in local.azs :
    az => {
      az   = az
      type = "private"
    }
  }

  public_subnet_tags_per_az = {
    for az in local.azs :
    az => {
      az   = az
      type = "public"
    }
  }

  igw_tags = {
    Name = "${local.environment}-${local.region}-igw"
  }

  nat_gateway_tags = {
    Name = "${local.environment}-${local.region}-nat-gw"
  }

  tags = {
    Environment = local.environment
    ManagedBy   = "Terraform"
  }

  vpc_tags = {
    Name = "${local.environment}-${local.region}-vpc"
  }
}

# =============================================================================

