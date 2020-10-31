resource "random_string" "ph-random" {
  length                            = 5
  upper                             = false
  special                           = false
}

resource "google_project" "ph-project" {
  name                              = "${var.ph_prefix}-project"
  project_id                        = "${var.ph_prefix}-project-${random_string.ph-random.result}"
  billing_account                   = var.gcp_billing_account
}

resource "google_project_service" "ph-project-compute-service" {
  project                           = google_project.ph-project.project_id
  service                           = "compute.googleapis.com"
}

resource "google_project_service" "ph-project-services" {
  count                             = length(var.gcp_project_services)
  project                           = google_project.ph-project.project_id
  service                           = var.gcp_project_services[count.index]
  depends_on                        = [google_project_service.ph-project-compute-service]
}
