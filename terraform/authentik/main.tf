data "sops_file" "this" {
  source_file = "secrets.sops.yaml"
}

data "authentik_flow" "default-authorization-flow" {
  slug = "default-provider-authorization-implicit-consent"
}

data "bitwarden_item_login" "oidc_creds" {
  id = var.github_oauth_credentials_id
}

resource "authentik_source_oauth" "github" {
  name = "github"
  slug = "github"

  authentication_flow = data.authentik_flow.default-authorization-flow.id
  enrollment_flow     = data.authentik_flow.default-authorization-flow.id

  provider_type   = "github"
  consumer_key    = data.bitwarden_item_login.oidc_creds.username
  consumer_secret = data.bitwarden_item_login.oidc_creds.password
}
