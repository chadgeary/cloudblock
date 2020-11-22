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
  
  ## Update / Ansible Rerun ##
  ssh ubuntu@${google_compute_address.ph-public-ip.address}
  cd /opt/cloudblock/
  sudo git pull
  cd playbooks/
  ansible-playbook cloudblock_gcp.yml --extra-vars 'docker_network=${var.docker_network} docker_gw=${var.docker_gw} docker_doh=${var.docker_doh} docker_pihole=${var.docker_pihole} docker_wireguard=${var.docker_wireguard} docker_webproxy=${var.docker_webproxy} wireguard_network=${var.wireguard_network} doh_provider=${var.doh_provider} dns_novpn=1 gcp_project_prefix=${var.ph_prefix} gcp_project_suffix=${random_string.ph-random.result} wireguard_peers=${var.wireguard_peers} vpn_traffic=${var.vpn_traffic}'
  OUTPUT
}
