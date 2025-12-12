output "name" {
  value = google_storage_bucket.static_doc.name
}

output "url" {
  value = "https://${google_storage_bucket.static_doc.name}.storage.googleapis.com/index.html"
}

# output "verification_token" {
#   value = data.google_site_verification_token.token.token
# }