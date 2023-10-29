resource "vault_audit" "file_audit" {
  type = "file"
  options = {
    file_path = "stdout"
  }
}


data "vault_policy_document" "policy_content" {
  for_each = { for k, v in var.roles : k => v if k != "default" }

  dynamic "rule" {
    for_each = each.value.rules
    content {
      path         = rule.value.path
      capabilities = rule.value.capabilities
      description  = lookup(rule.value, "description", null)
    }
  }
}

resource "vault_policy" "role_policy" {
  for_each = { for k, v in var.roles : k => v if k != "default" }
  name     = each.value.vault_policy_name
  policy   = data.vault_policy_document.policy_content[each.key].hcl
}

resource "vault_jwt_auth_backend" "okta_oidc" {
  description        = "Okta OIDC"
  type               = "oidc"
  path               = "oidc"
  oidc_discovery_url = var.okta_base_url_full
  oidc_client_id     = var.okta_client_id
  oidc_client_secret = var.okta_client_secret
  default_role       = "default"
  tune {
    listing_visibility = "unauth"
    default_lease_ttl  = "10h"
    max_lease_ttl      = "10h"
    token_type         = "default-service"
  }
}

resource "vault_jwt_auth_backend_role" "okta_role" {
  for_each       = var.roles
  backend        = vault_jwt_auth_backend.okta_oidc.path
  role_name      = each.key
  token_policies = each.value.token_policies

  allowed_redirect_uris = [
    "${var.vault_addr}/ui/vault/auth/${vault_jwt_auth_backend.okta_oidc.path}/oidc/callback",
    "http://127.0.0.1:8250/oidc/callback",
  ]

  user_claim      = "sub"
  role_type       = "oidc"
  bound_audiences = ["api://vault", var.okta_client_id]
  oidc_scopes     = ["groups"]
  bound_claims = {
    groups = join(",", each.value.bound_groups)
  }
  verbose_oidc_logging = false
}

resource "vault_identity_group" "group" {
  for_each = { for k, v in var.roles : k => v if k != "default" }

  name     = each.value.vault_identity_group
  type     = "external"
  policies = each.value.token_policies

  metadata = {
    responsibility = each.value.vault_identity_group
  }
}
