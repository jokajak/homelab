variable "name" {
  type        = string
  description = "The name of the oidc client application"
}

variable "slug" {
  type        = string
  description = "The slug of the oidc client application"
}

variable "redirect_uris" {
  type        = list(string)
  description = "The list of redirect uris where responses would be sent"
}

variable "client_id" {
  type        = string
  description = "The client id for the oidc client."
}

variable "client_secret" {
  type        = string
  sensitive   = true
  description = "The client secret for the oidc client"
}
