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

# variable "services" {
#   type = list(string)
# }

# resource "google_project_service" "services" {
#   project = google_project.project.project_id
#   for_each = toset(var.services)
#   service = each.value
# }