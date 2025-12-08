resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "instance" {
  name             = "ft-iac-db-${random_id.db_name_suffix.hex}"
  region           = var.region
  database_version = "MYSQL_8_0"

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_id
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
  password = var.db_password
}
