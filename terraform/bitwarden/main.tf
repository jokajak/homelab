resource "bitwarden_folder" "kubernetes_credentials" {
  name = "Kubernetes Credentials"
}

resource "random_password" "minio_password" {
  length           = 32
  special          = true
  override_special = "_=+-,~"
}

resource "bitwarden_item_login" "minio" {
  organization_id = var.terraform_organization
  collection_ids  = [var.collection_id]
  folder_id       = bitwarden_folder.kubernetes_credentials.id

  name     = "minio credentials"
  username = "Recoil7901"
  password = random_password.minio_password.result
}

output "minio_secrets" {
  value = bitwarden_item_login.minio.id
}
