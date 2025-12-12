resource "google_storage_bucket" "static_doc" {
  project = var.project_id

  name          = "doc-${var.project_name}"
  location      = var.region
  force_destroy = true
  storage_class = "STANDARD"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_storage_bucket_iam_member" "public_rule" {
  bucket = google_storage_bucket.static_doc.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

resource "google_storage_bucket_object" "doc_files_object" {
  for_each     = fileset("${var.dir_path}", "**")
  name         = each.value
  source       = "${var.dir_path}/${each.key}"
  content_type = lookup(var.mime_types, regex("\\.[^.]+$", each.value), "text/plain")
  bucket       = google_storage_bucket.static_doc.name
}