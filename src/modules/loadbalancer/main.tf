resource "google_compute_health_check" "hc" {
  name               = "ft-iac-hc-global"
  check_interval_sec = 5
  timeout_sec        = 5

  http_health_check {
    port         = 80
    request_path = "/health/liveness"
  }
}

resource "google_compute_backend_service" "backend" {
  name                  = "ft-iac-backend-global"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  timeout_sec           = 10
  health_checks         = [google_compute_health_check.hc.id]

  backend {
    group           = var.instance_group
    balancing_mode  = "UTILIZATION"
    max_utilization = 0.8
    capacity_scaler = 1.0
  }
}

resource "google_compute_url_map" "lb" {
  name            = "ft-iac-lb-global"
  default_service = google_compute_backend_service.backend.id
}

resource "google_compute_target_http_proxy" "proxy" {
  name    = "ft-iac-proxy-global"
  url_map = google_compute_url_map.lb.id
}

resource "google_compute_global_forwarding_rule" "frontend" {
  name       = "ft-iac-frontend-global"
  target     = google_compute_target_http_proxy.proxy.id
  port_range = "80"
}
