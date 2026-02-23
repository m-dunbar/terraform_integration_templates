# =============================================================================
# terraform_integration_templates :: terraform/modules/aws/subnets_from_ipam/main.tf
#       :: mdunbar :: 2026 Feb 21 :: MIT License © 2026 Matthew Dunbar ::
# =============================================================================
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc_ipam_pool_cidr_allocation" "private" {
  for_each       = toset(local.selected_azs)
  ipam_pool_id   = var.ipam_pool_id
  netmask_length = var.private_netmask
}

resource "aws_vpc_ipam_pool_cidr_allocation" "public" {
  for_each       = toset(local.selected_azs)
  ipam_pool_id   = var.ipam_pool_id
  netmask_length = var.public_netmask
}

resource "aws_subnet" "private" {
  for_each = aws_vpc_ipam_pool_cidr_allocation.private

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.key

  tags = {
    Name = "${var.environment}-eks-${var.cluster_label}-private-${each.key}"
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "public" {
  for_each = aws_vpc_ipam_pool_cidr_allocation.public

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.key

  tags = {
    Name = "${var.environment}-eks-${var.cluster_label}-public-${each.key}"
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
    "kubernetes.io/role/elb" = "1"
  }
}
# =============================================================================
