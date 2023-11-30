module "oidc_creds" {
  source          = "./oidc_creds"
  application     = "grafana"
  organization_id = var.organization_id
  collection_id   = var.collection_id

}

module "oidc_client" {
  source        = "./oidc_client"
  name          = "Grafana"
  slug          = "grafana"
  redirect_uris = ["https://grafana.${var.domain}/login/generic_oauth"]
  client_id     = module.oidc_creds.client_id
  client_secret = module.oidc_creds.client_secret
}

resource "authentik_group" "grafana_admins" {
  name = "Grafana Admins"
}

resource "authentik_group" "grafana_editors" {
  name = "Grafana Editors"
}

resource "authentik_group" "grafana_viewers" {
  name = "Grafana Viewers"
}
