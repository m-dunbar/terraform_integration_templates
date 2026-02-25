# =============================================================================
# terraform_integration_templates :: terraform/modules/aws/eks_cluster/data.tf
#       :: mdunbar :: 2026 Feb 24 :: MIT License © 2026 Matthew Dunbar ::
# =============================================================================
data "aws_eks_cluster" "this" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = local.cluster_name
}

# =============================================================================
