resource "google_compute_network" "vpc" {
  project = var.project_id

  name                    = "${var.project_name}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  project = var.project_id

  name          = "${var.project_name}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
}

resource "google_compute_router" "router" {
  project = var.project_id
  name    = "${var.project_name}-router"
  network = google_compute_network.vpc.name
  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  project = var.project_id

  name                               = "${var.project_name}-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_firewall" "allow_web" {
  project = var.project_id

  name    = "${var.project_name}-allow-web-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }

  source_ranges = ["0.0.0.0/0", "130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["web-server"]
}

resource "google_compute_global_address" "private_ip_address" {
  project = var.project_id

  name          = "${var.project_name}-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network         = google_compute_network.vpc.id
  deletion_policy = "ABANDON"

  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_compute_global_address" "default" {
  project      = var.project_id
  name         = "${var.project_name}-ip"
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
}

data "cloudflare_zone" "zone" {
  name = var.domain_name
}

resource "cloudflare_record" "dns_record_sub" {
  zone_id = data.cloudflare_zone.zone.id
  name    = var.subdomain
  value   = google_compute_global_address.default.address
  type    = "A"
  proxied = true
}

resource "google_compute_managed_ssl_certificate" "sub_cert" {
  project = var.project_id

  name = "${var.project_name}-cert-sub"

  managed {
    domains = ["${var.subdomain}.${var.domain_name}"]
  }
}