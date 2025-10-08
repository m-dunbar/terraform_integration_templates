/* ============================================================================
# terraform_integration_templates :: modules/auth0/templates/aws_role_mapping.js.tpl
#      :: mdunbar :: 2025 oct 06 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
Purpose:
  Map Auth0 user groups to AWS IAM roles for SAML federation.

Terraform variables:
  - environment
  - auth0_group_to_aws_role_arn_map (map<string, string>)
============================================================================ */
exports.onExecutePostLogin = async (event, api) => {
  const groupToRole = {
%{ for group, role_arn in auth0_group_to_aws_role_arn_map ~}
    "${group}": "${role_arn}",
%{ endfor ~}
  };

  // Determine which Auth0 groups map to AWS roles
  const userGroups = event.user.groups || [];
  const userRoles = userGroups
    .filter(group => groupToRole[group])
    .map(group => groupToRole[group]);

  if (userRoles.length > 0) {
    api.samlResponse.setAttribute("https://aws.amazon.com/SAML/Attributes/Role", userRoles);
    api.samlResponse.setAttribute("https://aws.amazon.com/SAML/Attributes/RoleSessionName", event.user.email);
    api.samlResponse.setAttribute("https://aws.amazon.com/SAML/Attributes/SessionDuration", "3600");
  }
};