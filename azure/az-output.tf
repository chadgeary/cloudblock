output "ph-ssh-out" {
  value                   = "ssh via: ssh ubuntu@${azurerm_public_ip.ph-public-ip.ip_address}"
}
