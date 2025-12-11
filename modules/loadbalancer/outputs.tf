output "lb_ip_http" {
  value = google_compute_global_forwarding_rule.http.ip_address
}

output "lb_ip_https" {
  value = google_compute_global_forwarding_rule.https.ip_address
}