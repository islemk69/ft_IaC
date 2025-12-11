resource "random_id" "project_suffix" {
  byte_length = 2
}

resource "google_project" "project" {
  billing_account     = var.billing_account
  name                = var.project_name
  project_id          = "${var.project_name}-${random_id.project_suffix.dec}"
  auto_create_network = false
  deletion_policy     = "DELETE"
}

resource "google_project_service" "compute_api" {
  project = google_project.project.project_id

  service            = "compute.googleapis.com"
  disable_on_destroy = true
}

resource "google_project_service" "networks_api" {
  project = google_project.project.project_id

  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = true
}

resource "google_project_service" "cloudresourcemanager" {
  project = google_project.project.project_id

  service            = "cloudresourcemanager.googleapis.com"
  disable_on_destroy = true
}

resource "google_project_service" "domains_api" {
  project = google_project.project.project_id

  service            = "domains.googleapis.com"
  disable_on_destroy = true
}

resource "google_project_service" "dns_api" {
  project = google_project.project.project_id

  service            = "dns.googleapis.com"
  disable_on_destroy = true
}
