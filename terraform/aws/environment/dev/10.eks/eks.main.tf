# =============================================================================
# terraform_integration_templates :: terraform/aws/environment/dev/10.eks/eks.main.tf
#       :: mdunbar :: 2026 Feb 21 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
# Supporting EKS pre-requisites
# -------------------------------------
# new IPAM subnets (two private, one per AZ, two public, one per AZ)
# module "subnets_from_ipam" {
#   source          = "../../../../modules/aws/subnets_from_ipam"
#   vpc_id          = data.aws_vpc.dev_vpc.id
#   ipam_pool_id    = data.aws_vpc_ipam_pool.source_pool.id

#   cluster_label    = "demo"
#   number_of_azs   = 2

#   private_netmask = 26
#   public_netmask  = 28
# }

module "eks_cluster" {
  environment   = local.environment
  cluster_label = local.cluster_label

  source     = "../../../../modules/aws/eks_cluster"
  vpc_id     = data.aws_vpc.dev_vpc.id
  subnet_ids = data.aws_subnets.dev_vpc_private_subnets.ids
  eks_managed_node_groups = local.eks_managed_node_groups

  tags       = local.tags
}

# =============================================================================
