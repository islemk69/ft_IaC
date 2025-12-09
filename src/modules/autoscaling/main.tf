resource "google_compute_instance_template" "app_template" {
  project                 = var.project_id

  name_prefix  = "ft-iac-template-"
  machine_type = var.machine_type
  region       = var.region

  tags = ["web-server"]

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-2204-lts"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network    = var.vpc_id
    subnetwork = var.subnet_id
  }

  metadata_startup_script = templatefile("${path.module}/scripts/user_data.sh", {
    DB_HOST = var.db_host
    DB_USER = var.db_user
    DB_PASS = var.db_password
    DB_NAME = var.db_name
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_region_instance_group_manager" "app_mig" {
  project                 = var.project_id

  name               = "ft-iac-mig"
  base_instance_name = "ft-iac-app"
  region             = var.region

  version {
    instance_template = google_compute_instance_template.app_template.id
  }

  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_region_autoscaler" "app_autoscaler" {
  project                 = var.project_id

  name   = "ft-iac-autoscaler"
  region = var.region
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
