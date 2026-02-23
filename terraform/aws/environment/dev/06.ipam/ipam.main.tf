# =============================================================================
# terraform_integration_templates :: terraform/aws/environment/dev/06.ipam/main.tf
#       :: mdunbar :: 2025 Oct 22 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
# Top-level IPAM provisioning
# -------------------------------------
resource "aws_vpc_ipam" "main" {
  description = "Central IPAM for Organization"

  operating_regions {
    region_name = "us-east-1"
  }

  operating_regions {
    region_name = "us-west-2"
  }
}

resource "aws_vpc_ipam_pool" "top_level" {
  description    = "Top-level private pool (for this AWS account)"
  
  ipam_scope_id  = aws_vpc_ipam.main.private_default_scope_id
  address_family = "ipv4"

  tags = {
    Name = "top_level"
  }
}

resource "aws_vpc_ipam_pool_cidr" "top_level_cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.top_level.id
  cidr         = "10.0.0.0/18"
}


# Dev provisioning
# -------------------------------------
resource "aws_vpc_ipam_pool" "dev_private_cidr" {
  description         = "Dev private subnet pool"
  
  ipam_scope_id       = aws_vpc_ipam.main.private_default_scope_id
  source_ipam_pool_id = aws_vpc_ipam_pool.top_level.id
  address_family      = "ipv4"

  tags = {
    Name = "dev_private_cidr"
  }
}

resource "aws_vpc_ipam_pool_cidr" "dev_private_cidr" {
  ipam_pool_id = aws_vpc_ipam_pool.dev_private_cidr.id
  cidr         = "10.0.48.0/24"
  
  depends_on = [aws_vpc_ipam_pool_cidr.top_level_cidr]
}

output "dev_private_cidr" {
  value = aws_vpc_ipam_pool_cidr.dev_private_cidr.cidr
}

# =============================================================================
