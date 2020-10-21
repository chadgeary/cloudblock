output "ph-web-out" {
  value                             = "pihole WebUI will be available @ https://${google_compute_address.ph-public-ip.address}/admin/"
}

output "ph-wireguard-out" {
  value                             = "Wireguard conf files will be available @ https://console.cloud.google.com/storage/browser/${var.ph_prefix}-bucket-${random_string.ph-random.result}/wireguard?project=${var.ph_prefix}-project-${random_string.ph-random.result}"
}

output "ph-ssh-out" {
  value                             = "ssh via: ssh ubuntu@${google_compute_address.ph-public-ip.address}"
}
