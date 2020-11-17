output "ssh-msg" {
  value                   = "ssh via: ssh ubuntu@${azurerm_public_ip.ph-public-ip.ip_address}"
}

output "wireguard-msg" {
  value                   = "Wireguard confs (one per device!) @ https://portal.azure.com/#blade/Microsoft_Azure_Storage/ContainerMenuBlade/overview/storageAccountId/%2Fsubscriptions%2F${data.azurerm_subscription.ph-subscription.subscription_id}%2FresourceGroups%2F${var.ph_prefix}-resourcegroup%2Fproviders%2FMicrosoft.Storage%2FstorageAccounts%2F${var.ph_prefix}store${random_string.ph-random.result}/path/${var.ph_prefix}-storage-container/defaultId/properties/publicAccessVal/None"
}

output "pihole-web-vpn-msg" {
  value                   = "pihole webUI also available (when on Wireguard VPN) @ https://${var.docker_webproxy}/admin/"
}

output "pihole-web-msg" {
  value                   = "pihole webUI @ https://${azurerm_public_ip.ph-public-ip.ip_address}/admin/"
}
