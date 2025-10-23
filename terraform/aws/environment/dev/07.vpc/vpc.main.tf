# =============================================================================
# terraform_integration_templates :: terraform/aws/environment/dev/07.vpc/main.tf
#       :: mdunbar :: 2025 Oct 22 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
module "vpc_dev" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.5.0"

  name                 = "dev-us-east-1"
  cidr                 = "10.0.48.0/24"      # DEV VPC
  azs                  = ["us-east-1a"]      # add AZ-b if needed
  public_subnets       = ["10.0.48.0/26"]
  private_subnets      = ["10.0.48.64/26"]

  enable_nat_gateway   = false               # start without, add if required
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = local.environment
    Name        = "DEV-VPC"
  }
}

# =============================================================================

