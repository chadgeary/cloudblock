output "cloudblock-output" {
value = <<OUTPUT

#############
## OUTPUTS ##
#############
# SSH #
ssh ubuntu@${scaleway_instance_ip.scw-ip.address}

# WebUI #
https://${scaleway_instance_ip.scw-ip.address}/admin/

## ##################### ##
## Ansible Service Setup ##
## ##################### ##
scp ${var.scw_prefix}-setup-${random_string.scw-random.result}.sh ubuntu@${scaleway_instance_ip.scw-ip.address}:~/${var.scw_prefix}-setup-${random_string.scw-random.result}.sh
ssh ubuntu@${scaleway_instance_ip.scw-ip.address} "chmod +x ${var.scw_prefix}-setup-${random_string.scw-random.result}.sh && ~/${var.scw_prefix}-setup-${random_string.scw-random.result}.sh"

## ################################################ ##
## Update Containers and Ansible Rerun Instructions ##
## ################################################ ##
ssh ubuntu@${scaleway_instance_ip.scw-ip.address}

# If updating containers, remove the old containers - this brings down the service until ansible is re-applied.
sudo docker rm -f cloudflared_doh pihole web_proxy wireguard

# Re-apply Ansible playbook via systemd service
sudo systemctl start cloudblock-ansible-state.service

## ########## ##
## Destroying ##
################
# Before terraform destroy, delete all objects from buckets using the aws CLI - this action is irreversible.
# Install awscli via pip3
sudo apt update && sudo DEBIAN_FRONTEND=noninteractive apt-get -q -y install python3-pip
pip3 install --user --upgrade awscli

# Set credentials
aws configure set aws_access_key_id ${var.scw_accesskey}
aws configure set aws_secret_access_key ${var.scw_secretkey}

# Remove objects
aws s3 rm --recursive s3://${var.scw_prefix}-backup-bucket-${random_string.scw-random.result}/ --endpoint https://s3.${var.scw_region}.scw.cloud --region ${var.scw_region}

OUTPUT
}
