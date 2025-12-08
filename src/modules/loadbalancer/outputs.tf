output "lb_ip" {
  value = google_compute_global_forwarding_rule.frontend.ip_address
}
