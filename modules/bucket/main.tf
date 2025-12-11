resource "google_storage_bucket" "static_doc" {
  project       = var.project_id
  name          = "${var.project_id}-bucket-doc"
  location      = var.region
  force_destroy = true
  storage_class = "STANDARD"


  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  # cors {
  #   origin          = ["http://${google_storage_bucket.static_doc}"]
  #   method          = ["GET", "HEAD",]
  #   response_header = ["*"]
  #   max_age_seconds = 3600
  # }

}

resource "google_storage_bucket_iam_member" "public_rule" {
  bucket = google_storage_bucket.static_doc.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}


resource "google_storage_bucket_object" "doc_files_object" {
  for_each = fileset("${var.dir_path}", "**")
  name     = each.value
  source   = each.key
  bucket   = google_storage_bucket.static_doc.name
}