#########################
#       PROVIDER        #
#########################

provider "google" {
  # Ton ID de projet (ex: ft-iac-project-480013)
  project = "ft-iac-project-480013" 
  
  region  = "europe-west9" # Paris
  zone    = "europe-west9-a"
}

#########################
#        NETWORK        #
#########################

resource "google_compute_network" "vpc" {
  name                    = "ft-iac-vpc"
  auto_create_subnetworks = false 
}

resource "google_compute_subnetwork" "subnet" {
  name          = "ft-iac-subnet"
  ip_cidr_range = "10.0.0.0/16"
  region        = "europe-west9"
  network       = google_compute_network.vpc.id
}

resource "google_compute_router" "router" {
  name    = "ft-iac-router"
  network = google_compute_network.vpc.name
  region  = google_compute_subnetwork.subnet.region
}

resource "google_compute_router_nat" "nat" {
  name                               = "ft-iac-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

#########################
#       FIREWALL        #
#########################

# 4. Autoriser SSH et HTTP
resource "google_compute_firewall" "allow_web" {
  name    = "allow-web-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  source_ranges = ["0.0.0.0/0", "130.211.0.0/22", "35.191.0.0/16"]
  
  target_tags   = ["web-server"]
}

#########################
#   INSTANCE TEMPLATE   #
#########################

resource "google_compute_instance_template" "app_template" {
  name_prefix  = "ft-iac-template-"
  machine_type = "e2-micro" 
  
  tags = ["web-server"]

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-2204-lts"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnet.id
  }

  metadata_startup_script = file("${path.module}/scripts/user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}

#########################
#    AUTOSCALING (MIG)  #
#########################

resource "google_compute_region_instance_group_manager" "app_mig" {
  name               = "ft-iac-mig"
  base_instance_name = "ft-iac-app"
  region             = "europe-west9"

  version {
    instance_template = google_compute_instance_template.app_template.id
  }

  named_port {
    name = "http"
    port = 80
  }

  target_size  = 2
}

##################################
#   LOAD BALANCER (GLOBAL HTTP)  #
##################################

resource "google_compute_health_check" "hc" {
  name               = "ft-iac-hc-global"
  check_interval_sec = 5
  timeout_sec        = 5
  
  http_health_check {
    port = 80
  }
}

resource "google_compute_backend_service" "backend" {
  name                  = "ft-iac-backend-global"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  timeout_sec           = 10
  health_checks         = [google_compute_health_check.hc.id]

  backend {
    group           = google_compute_region_instance_group_manager.app_mig.instance_group
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

#########################
#       OUTPUTS         #
#########################

output "load_balancer_ip" {
  value = google_compute_global_forwarding_rule.frontend.ip_address
}