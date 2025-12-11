resource "google_compute_url_map" "https_redirect" {
  project = var.project_id
  name    = "${var.project_name}-https-redirect"

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}
