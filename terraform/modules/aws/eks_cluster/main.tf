# =============================================================================
# terraform_integration_templates :: terraform/modules/aws/eks_cluster/main.tf
#       :: mdunbar :: 2026 Feb 21 :: MIT License © 2026 Matthew Dunbar ::
# =============================================================================
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.15"

  name    = local.cluster_name
  kubernetes_version = "1.35"

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # node_iam_role_name = aws_iam_role.eks_node_role.name

  cluster_tags = var.tags

  eks_managed_node_groups = var.eks_managed_node_groups
}

# =============================================================================
