# =============================================================================
# terraform_integration_templates :: environment/dev/iam/iam.role.terraform-provisioner.tf
#      :: mdunbar :: 2025 oct 05 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
resource "aws_iam_role" "terraform_provisioner" {
  name               = "terraform-provisioner"
  assume_role_policy = data.aws_iam_policy_document.assume_role_auth0.json
}

# Attach AWS managed AdministratorAccess policy
resource "aws_iam_role_policy_attachment" "terraform_provisioner_admin" {
  role       = aws_iam_role.terraform_provisioner.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
} # initial setup only, replace with least privilege policies later

# ==============================================================================
