# OIDC Auth with Okta

## Configure Okta

The [full guide is here](https://developer.hashicorp.com/vault/tutorials/auth-methods/vault-oidc-okta), but below is a shortened version.

### Set up Group and Application

1. Make a group called `admin-group` and add your user to it.
2. Create App Integration -> OIDC -> Web Application
3. Give it a name, and check "Implicit (hybrid)" under Grant Type
4. Change Sign-in redirect URLs to the following two: `http://127.0.0.1:8200/ui/vault/auth/oidc/oidc/callback`, `http://127.0.0.1:8250/oidc/callback`
5. Under Assignments, select "Skip group assignments for now" and save.
6. Go to the Sign On tab for your application, and edit "OpenID Connect ID Token"
7. Under "Group Claims Filter" select `Matches Regex` and add `.*` as a filter.  Save.
8. Under Assignment, add the `admin-group`.

### Update terraform.tfvars

1. Update `okta_base_url_full` to match your Okta dev instance.
2. Grab your application's Client ID and update `okta_client_id`
3. Copy your Client Secret and add export it as `TF_VAR_okta_client_secret` (seen below).

## Configure Vault Auth

```sh
cd terraform/oidc-auth-with-okta/

export VAULT_ADDR="http://127.0.0.1:8200"
export VAULT_TOKEN="root"
export TF_VAR_okta_client_secret="<your client secret>"

# Edit roles under terraform.tfvars to map different okta groups to different Vault roles.
# By default, we map admin-group to 3 roles: default, admin, power.

terraform init
terraform plan -out=plan
terraform apply plan
```

You should now be able to browse to http://127.0.0.1:8200 and log in with OIDC.

Try:

- leaving the role blank
- using role `admin`
- using role `power`

## Customize

You can add a new role by adding a new block under `roles`. Example:

- Create a role called `demo`.  Also create a policy called `demo` to match (vault_policy_name).
- Make sure the `demo` policy is attached (token_policies).  You could add more policies if you have them.
- Bind this role to the Okta group `demo-vault-users`.  Note: you'll need to make a new group in okta, assign your user, and assign the vault application to this group.

```
  demo = {
    vault_policy_name    = "demo"
    token_policies       = ["demo"]
    bound_groups         = ["demo-vault-users"]
    vault_identity_group = "demo"
    rules = [
      {
        path         = "secret/data/demo"
        capabilities = ["create", "read", "update", "delete"]
        description  = "Only able to CRUD a specific secret called demo"
      },
    ]
  }
```

Now if you log in under the `demo` role, you'll only be able to access a single secret called `demo`.  If it doesn't exist, it'll be the only secret you can create.
