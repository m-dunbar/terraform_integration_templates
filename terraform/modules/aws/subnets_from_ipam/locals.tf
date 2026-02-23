# =============================================================================
# terraform_integration_templates :: terraform/modules/aws/subnets_from_ipam/locals.tf
#       :: mdunbar :: 2026 Feb 21 :: MIT License © 2026 Matthew Dunbar ::
# =============================================================================
locals {
  cluster_name = "${var.environment}-${var.cluster_label}"

  selected_azs = slice(
    data.aws_availability_zones.available.names,
    0,
    var.number_of_azs
  )
}

# =============================================================================
