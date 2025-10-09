# =============================================================================
# terraform_integration_templates :: environment/dev/02.iam/iam.roles.auto.tfvars
#       :: mdunbar :: 2025 Oct 08 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
iam_role_list = [
  {
    role_name = "Administrators"
    managed_policy_arns = [
      "arn:aws:iam::aws:policy/AdministratorAccess"
    ]
  },
  {
    role_name = "Developers"
    managed_policy_arns = [
      "arn:aws:iam::aws:policy/PowerUserAccess"
    ]
  },
  {
    role_name = "ReadOnly"
    managed_policy_arns = [
      "arn:aws:iam::aws:policy/ReadOnlyAccess"
    ]
  },
]

# =============================================================================
