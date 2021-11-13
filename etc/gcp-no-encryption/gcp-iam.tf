data "google_iam_policy" "ph-service-account-iam-policy-data" {
  binding {
    role                              = "roles/iam.serviceAccountUser"
    members                           = ["user:${var.gcp_user}"]
  }
}

resource "google_service_account" "ph-service-account" {
  project                           = google_project.ph-project.project_id
  account_id                        = "${var.ph_prefix}-serviceaccount"
  display_name                      = "${var.ph_prefix}-serviceaccount"
}

resource "google_service_account_iam_policy" "ph-account-service-iam-policy" {
  service_account_id                = google_service_account.ph-service-account.name
  policy_data                       = data.google_iam_policy.ph-service-account-iam-policy-data.policy_data
}
