resource "google_secret_manager_secret" "ph-secret-password" {
  project                           = google_project.ph-project.project_id
  secret_id                         = "${var.ph_prefix}-web-password"
  replication {
    user_managed {
      replicas {
        location                          = var.gcp_region
      }
    }
  }
  depends_on                        = [google_project_service.ph-project-services]
}

resource "google_secret_manager_secret_version" "ph-secret-password-version" {
  secret                            = google_secret_manager_secret.ph-secret-password.id
  secret_data                       = var.ph_password
}

data "google_iam_policy" "ph-service-account-secret-data" {
  binding {
    role                              = "roles/secretmanager.secretAccessor"
    members                           = ["serviceAccount:${google_service_account.ph-service-account.email}"]
  }
}

resource "google_secret_manager_secret_iam_policy" "ph-service-account-secret-iam-policy" {
  project                           = google_project.ph-project.project_id
  secret_id                         = google_secret_manager_secret.ph-secret-password.secret_id
  policy_data                       = data.google_iam_policy.ph-service-account-secret-data.policy_data
}
