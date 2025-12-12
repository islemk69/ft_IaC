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

    ovh = {
      source  = "ovh/ovh"
      version = ">= 2.10"
    }
  }
}

provider "google" {
  region = local.selected_region
}

provider "ovh" {
  endpoint           = "ovh-eu"
  application_key    = var.ovh_app_key
  application_secret = var.ovh_app_secret
  consumer_key       = var.ovh_consumer_key
}