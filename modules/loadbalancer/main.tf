

resource "google_compute_health_check" "hc" {
  project = var.project_id

  name               = "${var.project_name}-hc-global"
  check_interval_sec = 5
  timeout_sec        = 5

  http_health_check {
    port         = 80
    request_path = "/health/liveness"
  }
}

resource "google_compute_backend_service" "backend" {
  project = var.project_id

  name                  = "${var.project_name}-backend-global"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  timeout_sec           = 10
  enable_cdn            = false
  session_affinity      = "GENERATED_COOKIE"
  health_checks         = [google_compute_health_check.hc.id]

  log_config {
    enable = true
  }

  backend {
    group           = var.instance_group
    balancing_mode  = "UTILIZATION"
    max_utilization = 0.8
    capacity_scaler = 1.0
  }
}

resource "google_compute_url_map" "lb" {
  project = var.project_id

  name            = "${var.project_name}-lb-global"
  default_service = google_compute_backend_service.backend.id
}

resource "google_compute_target_http_proxy" "proxy" {
  project = var.project_id

  name    = "${var.project_name}-proxy-global"
  url_map = google_compute_url_map.https_redirect.id
}

resource "google_compute_global_forwarding_rule" "http" {
  project = var.project_id

  name       = "${var.project_name}-frontend-global"
  target     = google_compute_target_http_proxy.proxy.id
  port_range = "80"
  ip_address = var.global_address
}

resource "google_compute_target_https_proxy" "proxy" {
  project = var.project_id

  name    = "${var.project_name}-https-proxy"
  url_map = google_compute_url_map.lb.id
  ssl_certificates = [
    var.cert_id
  ]
}

resource "google_compute_global_forwarding_rule" "https" {
  project = var.project_id

  name       = "${var.project_name}-https-frontend"
  target     = google_compute_target_https_proxy.proxy.id
  port_range = "443"
  ip_address = var.global_address
}