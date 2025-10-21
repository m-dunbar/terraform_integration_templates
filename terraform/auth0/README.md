# Auth0 configured as SAML Identity Provider

[Auth0](https://auth0.com) is a SOC2-compliant, identity-as-a-service (IDaaS) platform that provides authentication and authorization services for applications. It allows developers to securely manage user identities without building a custom identity solution from scratch. 

## Auth0 supports a variety of authentication methods, including:

-	Username/password (database)  
-	Social logins (Google, Facebook, GitHub, etc.)  
-	Enterprise SSO (SAML, OpenID Connect, WS-Federation)  
-	Passwordless login (email or SMS-based)  

### Key components

- Applications – Represent the apps that users log into (web, mobile, API)  
-	Connections – Define how users authenticate (database, social, enterprise)  
-	Users – Profiles of people who log in  
-	Rules / Actions – Customizable scripts to run during authentication  
(e.g., role mapping, adding claims to tokens)  
-	APIs – Define resources that applications can access securely.

### Use cases

-	Centralized login across multiple applications  
-	Enforcing multi-factor authentication (MFA)  
-	Role-based access control (RBAC)  
-	Integrating with third-party identity providers (IdPs) like Okta, Kerberos, or Azure AD

### Benefits

-	Reduces security risks by outsourcing authentication  
-	Scales easily for millions of users  
-	Supports standard protocols (OAuth2, OpenID Connect, SAML)  
-	Provides analytics and monitoring of logins and security events

## Terraform Configuration

Auth0 provides a [Terraform Provider](https://github.com/auth0/terraform-provider-auth0) for managing Auth0 configuration.  This integration implements Auth0 configuration by way of that provider.

### Requirements

- An Auth0 account
- An initial machine-to-machine application added manually within the Auth0 console with appropriate access priviliges.  (Initially, you may want to start with all, and then pare it back to a more specific subset later.)

### Implementation

Credentials should be added through the creation of a tfvars file (auth0.credentials.auto.tfvars).  _(This filename has been added to .gitignore, to ensure credentials are never commited to the git repository.)_

Example _auth0.credentials.auto.tfvars_:

```
# =============================================================================
# terraform_integration_templates :: auth0/auth0.credentials.auto.tfvars 
#      :: mdunbar :: 2025 oct 05 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
auth0_domain        = "<your-auth0-domain>.us.auth0.com"
auth0_client_id     = "<your-application-specific-client_id>"
auth0_client_secret = "<your-application-specific-client_secret>"

# =============================================================================
```

Users should be aded through the creation of a tfvars file (auth0.users.auto.tfvras).

Example _auth0.users.autho.tfvars_:

```
# =============================================================================
# terraform_integration_templates :: auth0/auth0.users.auto.tfvars
#       :: mdunbar :: 2025 Oct 07 :: MIT License © 2025 Matthew Dunbar ::
# =============================================================================
auth0_users = [
    {
      username       = "<username>"
      given_name     = "<given_name>"
      family_name    = "<family_name>"
      email          = "email@your_domain.com"
      group_ids      = ["admin"]
      verify_email   = true
    },
  ]

# =============================================================================
```

When ommitting the manual eddition of a password, Auth0 will automatically send an email with a link for the user to set a password.  A password must bw set by the user via that link before authentication for the user will work.

#### Applications

- **auth0.application.tf.m2m.tf** - Terraform Machine-to-Machine Application - providing access for Terraform-based management
- **auth0.application.aws.saml.tf** - AWS SAML Application - SAML Identity Provider (IdP) Source of Authority for user Identity Management

#### Roles

For defining Auth0 roles, role_names (and optional role_descriptions) are provided in **auth0.roles.auto.tfvars**

In this examples those include:

- \<environment\>-Administrator
- \<environment\>-Developer
- \<environment\>-ReadOnly

The environment prefix allows for environment-level granularity, as developers often have elevated priviledges in non-production environments.

#### Users

Auth0 provides centralized user management, allowing implementation and management for all Auth0 supported forms of authentication (including Enterprise SSO).

<hr>

© 2025 Matthew Dunbar  
(See LICENSE for details.)