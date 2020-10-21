resource "google_kms_key_ring" "ph-keyring" {
  name                              = "${var.ph_prefix}-keyring"
  location                          = var.gcp_region
  project                           = google_project.ph-project.project_id
  depends_on                        = [google_project_service.ph-project-services]
}

resource "google_kms_crypto_key" "ph-key-compute" {
  name                              = "${var.ph_prefix}-key-compute"
  key_ring                          = google_kms_key_ring.ph-keyring.id
  rotation_period                   = "100000s"
}

resource "google_kms_crypto_key_iam_binding" "ph-key-compute-binding" {
  crypto_key_id                     = google_kms_crypto_key.ph-key-compute.id
  role                              = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members                           = [
    "serviceAccount:service-${google_project.ph-project.number}@compute-system.iam.gserviceaccount.com"
  ]
}

resource "google_kms_crypto_key" "ph-key-storage" {
  name                              = "${var.ph_prefix}-key-storage"
  key_ring                          = google_kms_key_ring.ph-keyring.id
  rotation_period                   = "100000s"
}

resource "google_kms_crypto_key_iam_binding" "ph-key-storage-binding" {
  crypto_key_id                     = google_kms_crypto_key.ph-key-storage.id
  role                              = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members                           = [
    "serviceAccount:service-${google_project.ph-project.number}@gs-project-accounts.iam.gserviceaccount.com",
    "serviceAccount:${google_service_account.ph-service-account.email}"
  ]
  depends_on                        = [data.google_storage_project_service_account.ph-storage-account]
}
