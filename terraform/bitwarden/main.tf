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
}

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
  password = random_password.minio_password.result
}
