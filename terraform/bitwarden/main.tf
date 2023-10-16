locals {
  domain = data.sops_file.this.data["DOMAIN"]
}

################################################################################
# minio credentials
################################################################################
resource "random_password" "minio_password" {
  length           = 32
  special          = true
  override_special = "_=+-,~"
}

resource "bitwarden_item_login" "minio" {
  organization_id = var.terraform_organization
  collection_ids  = [var.collection_id]

  name     = "minio credentials"
  username = "Recoil7901"
  password = random_password.minio_password.result
  uri {
    value = "https://minio.${local.domain}"
    match = "host"
  }
}

################################################################################
# cloudnative postgres credentials
################################################################################
resource "random_password" "cloudnative_pg_user" {
  length  = 16
  special = false
}

resource "random_password" "cloudnative_pg_password" {
  length           = 32
  special          = true
  override_special = "_=+-,~"
}

resource "bitwarden_item_login" "cloudnative_pg" {
  organization_id = var.terraform_organization
  collection_ids  = [var.collection_id]

  name     = "cloudnative_pg credentials"
  username = random_password.cloudnative_pg_user.result
  password = random_password.cloudnative_pg_password.result
}

################################################################################
# authentik credentials
################################################################################
resource "random_password" "authentik_secret_key" {
  length           = 50
  special          = true
  override_special = "_=+-,~"
}

resource "bitwarden_item_login" "authentik" {
  organization_id = var.terraform_organization
  collection_ids  = [var.collection_id]

  name     = "authentik credentials"
  password = random_password.authentik_secret_key.result

  uri {
    value = "https://auth.${local.domain}]}"
    match = "host"
  }
}

################################################################################
# weave credentials
################################################################################
resource "random_password" "weave_password" {
  length           = 50
  special          = true
  override_special = "_=+-,~"
}

resource "bitwarden_item_login" "weave" {
  organization_id = var.terraform_organization
  collection_ids  = [var.collection_id]

  name     = "weave credentials"
  password = random_password.weave_password.result
}

################################################################################
# mosquitto credentials
################################################################################
resource "random_password" "mosquitto_username" {
  length  = 16
  special = false
}

resource "random_password" "mosquitto_password" {
  length           = 32
  special          = true
  override_special = "_=+-,~"
}

resource "bitwarden_item_login" "mosquitto" {
  organization_id = var.terraform_organization
  collection_ids  = [var.collection_id]

  name     = "mosquitto credentials"
  username = random_password.mosquitto_username.result
  password = random_password.mosquitto_password.result
}
