output "cloudblock-output" {
  value = <<OUTPUT

  #############
  ## OUTPUTS ##
  #############

  ## SSH (VPN) ##
  ssh ubuntu@${google_compute_address.ph-public-ip.address}
  (ssh ubuntu@${var.docker_gw})

  ## WebUI (VPN) ##
  https://${google_compute_address.ph-public-ip.address}/admin/
  (https://${var.docker_webproxy}/admin/)

  ## Wireguard Configurations ##
  https://console.cloud.google.com/storage/browser/${var.ph_prefix}-bucket-${random_string.ph-random.result}/wireguard?project=${var.ph_prefix}-project-${random_string.ph-random.result}
  OUTPUT
}
