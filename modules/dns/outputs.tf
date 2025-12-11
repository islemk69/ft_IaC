output "name_servers" {
  description = "Delegate your managed_zone to these virtual name servers"
  value       = google_dns_managed_zone.prod.name_servers
}
