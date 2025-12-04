# --- LOGIQUE D'ABSTRACTION DES INSTANCES ---
locals {
  machine_type_map = {
    "small"  = "e2-small"
    "medium" = "e2-medium"
    "large"  = "e2-standard-2"
  }
  selected_machine_type = lookup(local.machine_type_map, var.machine_type, "e2-small")
}

# ----------------------------------------------------
# A. CLOUD SQL (BASE DE DONNÉES) - Le bloc doit être en haut pour être lu en premier
# ----------------------------------------------------

resource "google_compute_global_address" "private_ip_address" {
  name          = "ft-iac-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id # Référence à network.tf
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "instance" {
  name             = "ft-iac-db-${random_id.db_name_suffix.hex}"
  region           = var.gcp_region # Utilise la variable
  database_version = "MYSQL_8_0"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc.id
    }
  }
  deletion_protection = false 
}

resource "google_sql_database" "database" {
  name     = "ft_iac_db"
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "users" {
  name     = "ft_iac_user"
  instance = google_sql_database_instance.instance.name
  password = var.db_password # Utilise la variable
}

# ----------------------------------------------------
# B. COMPUTE (Les ressources qui dépendent de la DB)
# ----------------------------------------------------

resource "google_compute_instance_template" "app_template" {
  name_prefix  = "ft-iac-template-"
  machine_type = local.selected_machine_type
  
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

  # LES RÉFÉRENCES NE SONT PLUS CASSÉES CAR ELLES SONT DANS LE MÊME FICHIER
  metadata_startup_script = templatefile("${path.module}/scripts/user_data.sh", {
    DB_HOST = google_sql_database_instance.instance.private_ip_address
    DB_USER = google_sql_user.users.name
    DB_PASS = google_sql_user.users.password
    DB_NAME = google_sql_database.database.name
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "app_mig" {
  name               = "ft-iac-mig"
  base_instance_name = "ft-iac-app"
  region             = var.gcp_region

  version {
    instance_template = google_compute_instance_template.app_template.id
  }

  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_region_autoscaler" "app_autoscaler" {
  name   = "ft-iac-autoscaler"
  region = var.gcp_region
  target = google_compute_region_instance_group_manager.app_mig.id

  autoscaling_policy {
    max_replicas    = 4  
    min_replicas    = 2 
    cooldown_period = 60 

    cpu_utilization {
      target = 0.6 
    }
  }
}