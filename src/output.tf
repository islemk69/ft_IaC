output "load_balancer_ip" {
  value = google_compute_global_forwarding_rule.frontend.ip_address
}

output "db_private_ip" {
  value = google_sql_database_instance.instance.private_ip_address
  sensitive = true
}