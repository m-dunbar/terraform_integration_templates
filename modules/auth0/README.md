# Auth0 module

While Auth0 provides a Terraform provisioner, it does not yet offer a supporting module.

This provides a module implementation for defintion and management of the following resources:

- application: creation of Auth0 applications (the basis of connections to Auth0)
- role: creation, update, and deletion of Auth0 roles
- saml_action: Auth0 to AWS role mapping
- user: creation, update, and deletion of Auth0 users, including role assignments

<hr>

© 2025 Matthew Dunbar  
(See LICENSE for details.)