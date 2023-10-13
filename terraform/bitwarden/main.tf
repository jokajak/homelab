resource "bitwarden_folder" "kubernetes_credentials" {
  name = "Kubernetes Credentials"
}

resource "random_password" "minio_password" {
  length           = 32
  special          = true
  override_special = "_=+-,~"
}

resource "bitwarden_item_login" "minio" {
  folder_id = bitwarden_folder.kubernetes_credentials.id

  name     = "minio credentials"
  username = "Recoil7901"
  password = random_password.minio_password.result
}
