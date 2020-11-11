output "pihole-web-msg" {
  value                             = "pihole WebUI will be available @ https://${google_compute_address.ph-public-ip.address}/admin/"
}

output "pihole-web-vpn-msg" {
  value                             = "pihole webUI also available (when on Wireguard VPN) @ https://${var.docker_pihole}/admin/" }

output "wireguard-msg" {
  value                             = "Wireguard confs (one per device!) @ https://console.cloud.google.com/storage/browser/${var.ph_prefix}-bucket-${random_string.ph-random.result}/wireguard?project=${var.ph_prefix}-project-${random_string.ph-random.result}"
}

output "ssh-msg" {
  value                             = "ssh via: ssh ubuntu@${google_compute_address.ph-public-ip.address}"
}
