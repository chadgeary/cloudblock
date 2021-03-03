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

#############
## UPDATES ##
#############

# SSH to server
ssh ubuntu@${google_compute_address.ph-public-ip.address}

# Remove containers (services are down until ansible step completes!)
sudo docker rm -f cloudflared_doh pihole web_proxy wireguard

# Re-apply Ansible playbook via systemctl
sudo systemctl start cloudblock-ansible-state.service

#############
## DESTROY ##
#############

# To destroy the project via terraform, run:
terraform destroy -var-file="gcp.tfvars"

OUTPUT
}
