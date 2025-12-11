resource "google_dns_managed_zone" "prod" {
  project     = var.project_id
  name        = "${var.project_name}-zone"
  dns_name    = "${var.domain_name}."
  description = "DNS Zone for ${var.domain_name}"
}

resource "google_dns_record_set" "frontend" {
  project = var.project_id
  name    = google_dns_managed_zone.prod.dns_name
  type    = "A"
  ttl     = 300

  managed_zone = google_dns_managed_zone.prod.name

  rrdatas = [var.lb_ip_address]
}
