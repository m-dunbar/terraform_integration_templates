# AWS Identity and Access Management (IAM) _[90% complete]_

Current AWS recommended best practice for access to AWS environments is via Role-Based Access Control (RBAC).  Permissions are assigned at the role level, and no users are created at all within the AWS account.  Users instead access the environment based upon permissions to assume specific roles, managed by way of SAML-based mappings within the Identity Provider (IdP).

In this example, Auth0 is the IdP.  Users are created within Auth0, and assigned to roles there, which in turn are mapped back to AWS IAM roles.  Those AWS roles are defined within the terraform here, as are supporting managed policies.  Policies are then mapped to those roles.

## Roles

- **terraform-provisioner**: this role provides access allowing terraform to perform provisioning within AWS.

- **\<environment\>-Administrator**: provides AWS Administrative access
- **\<environment>-Developer**: provides broad permissions, but not the ability to manage IAM (preventing direct privilege escalation)
- **\<environment\>-ReadOnly**: not commonly used (as 'ReadOnly' still requires a certain level of write permissions even to log in). This provides a fallback 'default' role with limited access.

## Policies

Policy assignments are a combination of both AWS-managed and customer Managed Policies.

## TODO

- complete module-based provisioning of roles other than terraform-provisioner

<hr>

© 2025 Matthew Dunbar  
(See LICENSE for details.)