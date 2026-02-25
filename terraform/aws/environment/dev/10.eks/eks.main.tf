# =============================================================================
# terraform_integration_templates :: terraform/aws/environment/dev/10.eks/eks.main.tf
#       :: mdunbar :: 2026 Feb 21 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
module "eks_cluster" {
  environment   = local.environment
  cluster_label = local.cluster_label
  region        = local.region

  source     = "../../../../modules/aws/eks_cluster"
  vpc_id     = data.aws_vpc.dev_vpc.id
  subnet_ids = data.aws_subnets.dev_vpc_private_subnets.ids
  eks_managed_node_groups = local.eks_managed_node_groups

  tags = local.tags
}

# =============================================================================
