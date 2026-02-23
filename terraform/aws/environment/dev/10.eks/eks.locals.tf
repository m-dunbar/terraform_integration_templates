# =============================================================================
# terraform_integration_templates :: terraform/aws/environment/dev/10.eks/eks.locals.tf
#       :: mdunbar :: 2026 Feb 21 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
locals {
  environment = "dev"
  cluster_label = "demo"
  source_ipam_pool_name = "top_level"

  tags = {
    Environment = local.environment
    ManagedBy   = "terraform"
    Project     = "EKS Demo"
  }
}

# =============================================================================
