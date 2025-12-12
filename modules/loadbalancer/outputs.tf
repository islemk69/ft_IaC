output "lb_ip" {
  value = google_compute_global_forwarding_rule.https.ip_address
}

output "url" {
  value = "https://${var.subdomain}.${var.domain_name}"
}