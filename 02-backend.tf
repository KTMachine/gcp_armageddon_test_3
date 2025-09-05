# https://www.terraform.io/language/settings/backends/gcs
terraform {
  backend "gcs" {
    bucket = "terraforminvictus2"
    prefix = "terraform/state"
    credentials = "invictus-65-68db3f022f9f.json"

  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}
