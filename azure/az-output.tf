output "cloudblock-output" {
  value = <<OUTPUT

  #############
  ## OUTPUTS ##
  #############

  ## SSH (VPN) ##
  ssh ubuntu@${azurerm_public_ip.ph-public-ip.ip_address}
  (ssh ubuntu@${var.docker_gw})

  ## WebUI (VPN) ##
  https://${azurerm_public_ip.ph-public-ip.ip_address}/admin/
  (https://${var.docker_webproxy}/admin/)

  ## Wireguard Configurations ##
  https://portal.azure.com/#blade/Microsoft_Azure_Storage/ContainerMenuBlade/overview/storageAccountId/%2Fsubscriptions%2F${data.azurerm_subscription.ph-subscription.subscription_id}%2FresourceGroups%2F${var.ph_prefix}-resourcegroup%2Fproviders%2FMicrosoft.Storage%2FstorageAccounts%2F${var.ph_prefix}store${random_string.ph-random.result}/path/${var.ph_prefix}-storage-container/defaultId/properties/publicAccessVal/None

  ## Update Containers / Ansible Rerun Instructions ##
  ssh ubuntu@${azurerm_public_ip.ph-public-ip.ip_address}

  # If updating containers, remove the old containers - this brings down the service until ansible is re-applied.
  sudo docker rm -f cloudflared_doh pihole web_proxy wireguard

  # Update project
  cd /opt/cloudblock/
  sudo git pull

  # Re-apply Ansible playbook with custom variables
  cd playbooks/
  ansible-playbook cloudblock_azure.yml --extra-vars 'docker_network=${var.docker_network} docker_gw=${var.docker_gw} docker_doh=${var.docker_doh} docker_pihole=${var.docker_pihole} docker_wireguard=${var.docker_wireguard} docker_webproxy=${var.docker_webproxy} wireguard_network=${var.wireguard_network} doh_provider=${var.doh_provider} dns_novpn=1 ph_prefix=${var.ph_prefix} ph_suffix=${random_string.ph-random.result} wireguard_peers=${var.wireguard_peers} vpn_traffic=${var.vpn_traffic}'
  OUTPUT
}
