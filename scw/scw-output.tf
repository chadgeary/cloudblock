output "cloudblock-output" {
value = <<OUTPUT

#############
## OUTPUTS ##
#############
# SSH #
ssh ubuntu@${scaleway_instance_ip.scw-ip.address}

# WebUI #
https://${scaleway_instance_ip.scw-ip.address}/admin/

#############
## INSTALL ##
#############

# Transfer installation script to server
scp ${var.scw_prefix}-setup-${random_string.scw-random.result}.sh ubuntu@${scaleway_instance_ip.scw-ip.address}:~/${var.scw_prefix}-setup-${random_string.scw-random.result}.sh

# Execute installation script
ssh ubuntu@${scaleway_instance_ip.scw-ip.address} "chmod +x ${var.scw_prefix}-setup-${random_string.scw-random.result}.sh && ~/${var.scw_prefix}-setup-${random_string.scw-random.result}.sh"

#############
## UPDATES ##
#############

# SSH to server
ssh ubuntu@${scaleway_instance_ip.scw-ip.address}

# Remove containers (services are down until ansible step completes!)
sudo docker rm -f cloudflared_doh pihole web_proxy wireguard

# Re-apply ansible playbook via systemctl
sudo systemctl start cloudblock-ansible-state.service

#############
## DESTROY ##
#############

# Before terraform destroy, delete all objects from buckets using the aws CLI - this action is irreversible.
# Install awscli via pip3
sudo apt update && sudo DEBIAN_FRONTEND=noninteractive apt-get -q -y install python3-pip
pip3 install --user --upgrade awscli

# Set credentials
aws configure set aws_access_key_id ${var.scw_accesskey}
aws configure set aws_secret_access_key ${var.scw_secretkey}

# Remove objects
aws s3 rm --recursive s3://${var.scw_prefix}-backup-bucket-${random_string.scw-random.result}/ --endpoint https://s3.${var.scw_region}.scw.cloud --region ${var.scw_region}

# then, use terraform destroy as normal
terraform destroy -var-file="scw.tfvars"

OUTPUT
}
