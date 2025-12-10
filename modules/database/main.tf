resource "random_id" "db_password" {
  byte_length = 4
}

resource "google_sql_database_instance" "instance" {
  project = var.project_id

  name             = "${var.project_name}-db"
  region           = var.region
  database_version = "MYSQL_8_0"

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_id
    }

    backup_configuration {
      enabled = true
      backup_retention_settings {
        retained_backups = 15
        retention_unit   = "COUNT"
      }
    }
  }
  deletion_protection = false
}

resource "google_sql_database" "database" {
  project = var.project_id

  name     = "${var.project_name}-db"
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_user" "users" {
  project = var.project_id

  name     = "${var.project_name}-user"
  instance = google_sql_database_instance.instance.name
  password = random_id.db_password.hex
}
