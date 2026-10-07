terraform {
  required_version = ">= 1.7.0"
}

variable "container_image" {
  type        = string
  description = "Public GHCR image published by the final-project workflow, pinned to a commit SHA."
}

module "application" {
  source          = "../../cloud-terraform"
  container_image = var.container_image
  container_port  = 8080
}

output "web_url" {
  value = module.application.web_url
}

output "bucket_name" {
  value = module.application.bucket_name
}
