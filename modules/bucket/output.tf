output "name" {
  value = google_storage_bucket.static_doc.name
}

output "url" {
  value = "https://${google_storage_bucket.static_doc.name}.storage.googleapis.com/index.html"
}