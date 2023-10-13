variable "terraform_organization" {
  type        = string
  description = "My Cloud Organization"
}

variable "collection_ids" {
  type        = list(string)
  description = "Collection to store resources in"
}
