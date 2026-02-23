# =============================================================================
# terraform_integration_templates :: terraform/modules/aws/eks_cluster/iam.node_role.tf
#       :: mdunbar :: 2026 Feb 21 :: MIT License © 2026 Matthew Dunbar ::
# =============================================================================
# Role
resource "aws_iam_role" "eks_node_role" {
  name               = "${var.environment}-${var.cluster_label}-eks-node-role"
  assume_role_policy = data.aws_iam_policy_document.eks_node_trust_policy.json
}

# Service Trust Policy for EKS Node Role - allows EC2 instances to assume this role
data "aws_iam_policy_document" "eks_node_trust_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# AWS Managed Policies and Attachments
# -- AmazonEKSWorkerNodePolicy -- for EKS worker node permissions
data "aws_iam_policy" "eks_worker_policy" {
  name = "AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_worker_attach" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = data.aws_iam_policy.eks_worker_policy.arn
}

# -- ECR ReadOnly policy -- for pulling container images from ECR
data "aws_iam_policy" "ecr_readonly_policy" {
  name = "AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "node_ecr_attach" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = data.aws_iam_policy.ecr_readonly_policy.arn
}

# -- Container Network Interface policy -- required for CNI plugin to manage ENIs for pods
data "aws_iam_policy" "eks_cni_policy" {
  name = "AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "node_cni_attach" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = data.aws_iam_policy.eks_cni_policy.arn
}

# =============================================================================
