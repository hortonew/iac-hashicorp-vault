# Provided by environment varaibles
# TF_VAR_okta_client_secret = ""

# Vault
vault_addr = "http://127.0.0.1:8200"

# Okta / OIDC
okta_base_url      = "okta.com"
okta_base_url_full = "https://dev-79013989.okta.com"
okta_client_id     = "0oad004tt3arzMJaW5d7"

roles = {
  default = {
    vault_policy_name    = "" # unused, mimics structure of others
    token_policies       = ["default"]
    bound_groups         = ["admin-group"]
    vault_identity_group = "default"
    rules                = [] # unused
  }
  admin = {
    vault_policy_name    = "admins"
    token_policies       = ["admins"]
    bound_groups         = ["admin-group"]
    vault_identity_group = "admins"
    rules = [
      {
        path         = "*"
        capabilities = ["create", "read", "update", "delete", "list", "sudo"]
        description  = "Access everything."
      },
    ]
  }
  power = {
    vault_policy_name    = "power"
    token_policies       = ["power"]
    bound_groups         = ["admin-group"]
    vault_identity_group = "power"
    rules = [
      {
        path         = "secret/metadata/*"
        capabilities = ["list"]
        description  = "List secrets"
      },
      {
        path         = "secret/data/*"
        capabilities = ["create", "read", "update", "delete", "list"]
        description  = "View customer secrets"
      },
    ]
  }
}
