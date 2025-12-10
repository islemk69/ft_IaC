output "db_instance_ip" {
  value = google_sql_database_instance.instance.private_ip_address
}

output "db_name" {
  value = google_sql_database.database.name
}

output "db_user" {
  value = google_sql_user.users.name
}

output "db_password" {
  value     = google_sql_user.users.password
  sensitive = true
}

output "instance_name" {
  value = google_sql_database_instance.instance.name
}
