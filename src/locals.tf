locals {
  # Region Mapping
  region_map = {
    "Paris"     = "europe-west9"
    "Frankfurt" = "europe-west3"
    "US"        = "us-central1"
  }
  selected_region = lookup(local.region_map, var.gcp_region, "us-central1")

  # Machine Type Mapping
  machine_type_map = {
    "small"  = "e2-small"
    "medium" = "e2-medium"
    "large"  = "e2-standard-2"
  }
  selected_machine_type = lookup(local.machine_type_map, var.machine_type, "e2-small")
}