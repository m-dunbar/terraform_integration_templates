# =============================================================================
# terraform_integration_templates :: terraform/modules/aws/eks_cluster/locals.tf
#       :: mdunbar :: 2026 Feb 21 :: MIT License © 2026 Matthew Dunbar ::
# =============================================================================
locals {
    cluster_name = "${var.environment}-${var.cluster_label}"
}
# =============================================================================
