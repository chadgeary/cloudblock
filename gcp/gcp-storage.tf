data "google_storage_project_service_account" "ph-storage-account" {
  project                           = google_project.ph-project.project_id
}

resource "google_storage_bucket" "ph-bucket" {
  name                              = "${var.ph_prefix}-bucket-${random_string.ph-random.result}"
  location                          = var.gcp_region
  project                           = google_project.ph-project.project_id
  encryption {
    default_kms_key_name              = google_kms_crypto_key.ph-key-storage.id
  }
  versioning {
    enabled                           = true
  }
  depends_on                        = [google_kms_crypto_key_iam_binding.ph-key-storage-binding]
  force_destroy                     = true
}

resource "google_storage_bucket_acl" "ph-bucket-acl" {
  bucket                            = google_storage_bucket.ph-bucket.name
  role_entity                       = [
    "OWNER:project-owners-${google_project.ph-project.number}",
    "OWNER:project-editors-${google_project.ph-project.number}",
    "READER:project-viewers-${google_project.ph-project.number}",
    "OWNER:user-${var.gcp_user}",
    "OWNER:user-${google_service_account.ph-service-account.email}"
  ]
}
