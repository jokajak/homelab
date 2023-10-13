terraform {
  required_providers {
    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = ">= 0.7.0"
    }
    sops = {
      source  = "carlpett/sops"
      version = "~> 1.0"
    }
  }
}

provider "bitwarden" {
  master_password = data.sops_file.this.data["BW_PASSWORd"]
  client_id       = data.sops_file.this.data["BW_CLIENTID"]
  client_secret   = data.sops_file.this.data["BW_CLIENTSECRET"]
  email           = data.sops_file.this.data["BW_EMAIL"]
  server          = "https://vault.bitwarden.com"
}
