terraform {

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  region = local.selected_region
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}