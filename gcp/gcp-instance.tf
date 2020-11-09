data "google_compute_image" "ph-gcp-image" {
  project                           = var.gcp_image_project
  name                              = var.gcp_image_name
}

resource "google_compute_address" "ph-public-ip" {
  name                              = "${var.ph_prefix}-public-ip"
  project                           = google_project.ph-project.project_id
  region                            = var.gcp_region
  address_type                      = "EXTERNAL"
  network_tier                      = "STANDARD"
  depends_on                        = [google_project_service.ph-project-services]
}

resource "google_compute_instance" "ph-instance" {
  name                              = "${var.ph_prefix}-instance"
  zone                              = "${var.gcp_region}-${var.gcp_zone}"
  machine_type                      = var.gcp_machine_type
  project                           = google_project.ph-project.project_id
  metadata                          = {
    ssh-keys                          = "${var.ssh_user}:${var.ssh_key}"
    startup-script                    = "#!/bin/bash\nDNS_SERVER='169.254.169.254'\nDNS_SEARCH=$(grep '^search ' /etc/resolv.conf)\nsystemctl disable systemd-resolved\nsystemctl stop systemd-resolved\nrm -f /etc/resolv.conf\ntee /etc/resolv.conf << EOM\nnameserver $DNS_SERVER\noptions edns0\n$DNS_SEARCH\nEOM\napt-get update\nDEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip git\npip3 install --upgrade ansible\nmkdir /opt/cloudblock\ngit clone ${var.project_url} /opt/cloudblock/\ncd /opt/cloudblock/\ngit pull\ncd playbooks/\nansible-playbook cloudblock_gcp.yml --extra-vars 'docker_network=${var.docker_network} docker_gw=${var.docker_gw} docker_doh=${var.docker_doh} docker_pihole=${var.docker_pihole} docker_wireguard=${var.docker_wireguard} docker_webproxy=${var.docker_webproxy} wireguard_network=${var.wireguard_network} doh_provider=${var.doh_provider} dns_novpn=1 gcp_project_prefix=${var.ph_prefix} gcp_project_suffix=${random_string.ph-random.result} wireguard_peers=${var.wireguard_peers} vpn_traffic=${var.vpn_traffic}' >> /var/log/cloudblock.log"
  }
  boot_disk {
    kms_key_self_link                 = google_kms_crypto_key.ph-key-compute.self_link
    initialize_params {
      image                             = data.google_compute_image.ph-gcp-image.self_link
      type                              = "pd-standard"
    }
  }
  network_interface {
    subnetwork                        = google_compute_subnetwork.ph-subnetwork.self_link
    network_ip                        = var.gcp_instanceip
    access_config {
      nat_ip                            = google_compute_address.ph-public-ip.address
      network_tier                      = "STANDARD"
    }
  }
  service_account {
    email                             = google_service_account.ph-service-account.email
    scopes                            = ["cloud-platform","storage-rw"]
  }
  allow_stopping_for_update         = true
  depends_on                        = [google_kms_crypto_key_iam_binding.ph-key-compute-binding,google_service_account_iam_policy.ph-account-service-iam-policy,google_storage_bucket.ph-bucket]
}
