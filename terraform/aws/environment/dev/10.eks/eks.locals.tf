# =============================================================================
# terraform_integration_templates :: terraform/aws/environment/dev/10.eks/eks.locals.tf
#       :: mdunbar :: 2026 Feb 21 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
locals {
  environment = "dev"
  cluster_label = "demo"
  source_ipam_pool_name = "dev_private_cidr"

  eks_managed_node_groups = {
    demo = {
      name           = "${local.environment}-${local.cluster_label}"
      desired_size   = 2
      min_size       = 1
      max_size       = 3
      instance_types = ["t3.large"] # medium appears to be the smallest viable node size - increase as needed
    }
  }

  tags = {
    Environment = local.environment
    ManagedBy   = "terraform"
    Project     = "EKS Demo"
  }
}

# =============================================================================
