resource "google_compute_network" "ph-network" {
  name                              = "${var.ph_prefix}-network"
  project                           = google_project.ph-project.project_id
  auto_create_subnetworks           = false
  depends_on                        = [google_project_service.ph-project-compute-service]
}

resource "google_compute_subnetwork" "ph-subnetwork" {
  name                              = "${var.ph_prefix}-subnetwork"
  project                           = google_project.ph-project.project_id
  network                           = google_compute_network.ph-network.id
  ip_cidr_range                     = var.gcp_cidr
  region                            = var.gcp_region
}

resource "google_compute_firewall" "ph-firewall-mgmt" {
  name                              = "${var.ph_prefix}-firewall-mgmt"
  project                           = google_project.ph-project.project_id
  network                           = google_compute_network.ph-network.self_link
  source_ranges                     = [var.mgmt_cidr]
  allow {
    protocol                          = "tcp"
    ports                             = ["22","443"]
  }
}

resource "google_compute_firewall" "ph-firewall-vpn" {
  name                              = "${var.ph_prefix}-firewall-vpn"
  project                           = google_project.ph-project.project_id
  network                           = google_compute_network.ph-network.self_link
  source_ranges                     = [var.vpn_cidr]
  allow {
    protocol                          = "udp"
    ports                             = ["51820"]
  }
}

# if dns_novpn = 1, these rules are added
resource "google_compute_firewall" "ph-firewall-mgmt-dnstcp" {
  count                             = var.dns_novpn * 1
  name                              = "${var.ph_prefix}-firewall-mgmt-dnstcp"
  project                           = google_project.ph-project.project_id
  network                           = google_compute_network.ph-network.self_link
  source_ranges                     = [var.mgmt_cidr]
  allow {
    protocol                          = "tcp"
    ports                             = ["53"]
  }
}

resource "google_compute_firewall" "ph-firewall-mgmt-dnsudp" {
  count                             = var.dns_novpn * 1
  name                              = "${var.ph_prefix}-firewall-mgmt-dnsudp"
  project                           = google_project.ph-project.project_id
  network                           = google_compute_network.ph-network.self_link
  source_ranges                     = [var.mgmt_cidr]
  allow {
    protocol                          = "udp"
    ports                             = ["53"]
  }
}
