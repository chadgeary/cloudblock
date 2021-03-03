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

#############
## UPDATES ##
#############

# SSH to server
ssh ubuntu@${azurerm_public_ip.ph-public-ip.ip_address}

# Remove containers (services are down until ansible step completes!)
sudo docker rm -f cloudflared_doh pihole web_proxy wireguard

# Re-apply Ansible playbook via systemctl
sudo systemctl start cloudblock-ansible-state.service

#############
## DESTROY ##
#############

# To destroy the project via terraform
terraform destroy -var-file="gcp.tfvars"

OUTPUT
}
