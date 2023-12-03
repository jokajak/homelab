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

################################################################################
# Flow management
#
# The intention is to allow login with social logins like github and google
################################################################################
# Create identification stage with sources and showing a password field

data "authentik_source" "inbuilt" {
  managed = "goauthentik.io/sources/inbuilt"
}

data "authentik_flow" "default-authentication-flow" {
  slug = "default-authentication-flow"
}

data "authentik_flow" "default-source-enrollment" {
  slug = "default-source-enrollment"
}

resource "authentik_stage_password" "inbuilt" {
  name     = "show-password-field"
  backends = ["authentik.core.auth.InbuiltBackend"]
}

resource "authentik_stage_identification" "name" {
  name            = "default-authentication-flow"
  user_fields     = ["username", "email"]
  sources         = [data.authentik_source.inbuilt.uuid, authentik_source_oauth.github.uuid]
  password_stage  = authentik_stage_password.inbuilt.id
  enrollment_flow = data.authentik_flow.default-source-enrollment.id
}

resource "authentik_flow_stage_binding" "identification" {
  target = data.authentik_flow.default-authentication-flow.id
  stage  = authentik_stage_identification.name.id
  order  = 10
}
