variable "vault_addr" { type = string }
variable "okta_base_url" { type = string }
variable "okta_base_url_full" { type = string }
variable "okta_client_id" { type = string }
variable "okta_client_secret" {
  type      = string
  sensitive = true
}
variable "roles" {
  type        = map(any)
  default     = {}
  description = "Map of Vault role names to their configurations"
}
