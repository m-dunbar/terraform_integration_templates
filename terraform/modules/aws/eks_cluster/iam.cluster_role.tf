# =============================================================================
# terraform_integration_templates :: terraform/modules/aws/eks_cluster/iam.cluster_role.tf
#       :: mdunbar :: 2026 Feb 21 :: MIT License © 2026 Matthew Dunbar ::
# =============================================================================
# Role
resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.environment}-${var.cluster_label}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_trust_policy.json
}

# Service Trust Policy for EKS Cluster Role - allows EKS service to assume this role
data "aws_iam_policy_document" "eks_cluster_trust_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# AWS Managed Policies and Attachments
# -- AmazonEKSClusterPolicy -- for EKS cluster permissions
data "aws_iam_policy" "eks_cluster_policy" {
  name = "AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "cluster_attach" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = data.aws_iam_policy.eks_cluster_policy.arn
}

# =============================================================================
