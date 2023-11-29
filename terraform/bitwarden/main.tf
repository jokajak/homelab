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

  field {
    name = "terraform"
    text = "true"
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

  field {
    name = "terraform"
    text = "true"
  }
}

################################################################################
# authentik credentials
################################################################################
resource "random_password" "authentik_secret_key" {
  length           = 50
  special          = true
  override_special = "_=+-,~"
}

resource "random_password" "authentik_pguser" {
  length           = 12
  special          = false
  override_special = "_=+-,~"
}

resource "random_password" "authentik_pgpass" {
  length           = 32
  special          = true
  override_special = "_=+-,~"
}

resource "bitwarden_item_login" "authentik" {
  organization_id = var.terraform_organization
  collection_ids  = [var.collection_id]

  name     = "authentik credentials"
  password = random_password.authentik_secret_key.result

  uri {
    value = "https://auth.${local.domain}"
    match = "host"
  }

  field {
    name = "terraform"
    text = "true"
  }
}

resource "bitwarden_item_login" "authentik_pgcreds" {
  organization_id = var.terraform_organization
  collection_ids  = [var.collection_id]

  name     = "authentik pgcreds"
  username = random_password.authentik_pguser.result
  password = random_password.authentik_pgpass.result

  notes = "Used for connecting authentik to the postgres database"

  field {
    name    = "terraform"
    boolean = true
  }
}

resource "random_password" "authentik_redis_secret" {
  length           = 32
  special          = true
  override_special = "_=+-,~"
}

resource "bitwarden_item_login" "authentik_redis" {
  organization_id = var.terraform_organization
  collection_ids  = [var.collection_id]

  name     = "authentik redis"
  password = random_password.authentik_redis_secret.result

  field {
    name = "terraform"
    text = "true"
  }
}

resource "random_password" "authentik_terraform_password" {
  length           = 32
  special          = true
  override_special = "_=+-,~"
}

resource "random_password" "authentik_terraform_client_id" {
  length  = 16
  special = false
}

resource "random_password" "authentik_terraform_token" {
  length           = 32
  special          = true
  override_special = "_=+-,~"
}

resource "bitwarden_item_login" "authentik_terraform_creds" {
  organization_id = var.terraform_organization
  collection_ids  = [var.collection_id]

  name     = "authentik terraform creds"
  username = random_password.authentik_terraform_client_id.result
  password = random_password.authentik_terraform_token.result

  field {
    name    = "terraform managed"
    boolean = true
  }

  field {
    name   = "user_pass"
    hidden = random_password.authentik_terraform_password.result
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

  field {
    name = "terraform"
    text = "true"
  }
}

################################################################################
# grafana credentials
################################################################################
resource "random_password" "grafana_username" {
  length  = 16
  special = false
}

resource "random_password" "grafana_password" {
  length           = 32
  special          = true
  override_special = "_=+-,~"
}

resource "bitwarden_item_login" "grafana" {
  organization_id = var.terraform_organization
  collection_ids  = [var.collection_id]

  name     = "grafana credentials"
  username = random_password.grafana_username.result
  password = random_password.grafana_password.result

  field {
    name = "terraform"
    text = "true"
  }

  uri {
    value = "https://grafana.${local.domain}"
    match = "host"
  }

}
