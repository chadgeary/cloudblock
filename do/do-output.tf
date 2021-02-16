resource "local_file" "do_setup" {
  filename                          = "${var.do_prefix}-setup-${random_string.do-random.result}.sh"
  content                           = <<FILECONTENT
# Create systemd service unit file
sudo tee /etc/systemd/system/cloudblock-ansible-state.service << EOM
[Unit]
Description=cloudblock-ansible-state
After=network.target

[Service]
ExecStart=/opt/cloudblock-ansible-state.sh
Type=simple
Restart=on-failure
RestartSec=30

[Install]
WantedBy=multi-user.target
EOM

# Create systemd timer unit file
sudo tee /etc/systemd/system/cloudblock-ansible-state.timer << EOM
[Unit]
Description=Starts cloudblock ansible state playbook 1min after boot

[Timer]
OnBootSec=1mi
nUnit=cloudblock-ansible-state.service

[Install]
WantedBy=multi-user.target
EOM

# Create cloudblock-ansible-state script
sudo tee /opt/cloudblock-ansible-state.sh << EOM
#!/bin/bash
# Update package list
apt-get update
# Install pip3 and git
DEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip git
# Update pip
pip3 install --upgrade pip
# Install ansible
pip3 install --upgrade ansible
# Make the project directory
mkdir -p /opt/git/cloudblock
# Clone project into project directory
git clone ${var.project_url} /opt/git/cloudblock
# Change to directory
cd /opt/git/cloudblock
# Ensure up-to-date
git pull
# Change to playbooks directory
cd playbooks/
# Execute playbook
ansible-playbook cloudblock_do.yml --extra-vars 'docker_network=${var.docker_network} docker_gw=${var.docker_gw} docker_doh=${var.docker_doh} docker_pihole=${var.docker_pihole} docker_wireguard=${var.docker_wireguard} docker_webproxy=${var.docker_webproxy} wireguard_network=${var.wireguard_network} doh_provider=${var.doh_provider} dns_novpn=${var.dns_novpn} wireguard_peers=${var.wireguard_peers} vpn_traffic=${var.vpn_traffic} do_prefix=${var.do_prefix} do_suffix=${random_string.do-random.result} ph_password=${var.ph_password} do_region=${var.do_region} do_storageaccessid=${var.do_storageaccessid} do_storagesecretkey=${var.do_storagesecretkey}' >> /var/log/cloudblock.log
EOM

# Start / Enable cloudblock-ansible-state
sudo chown root:root /opt/cloudblock-ansible-state.sh
sudo chmod 500 /opt/cloudblock-ansible-state.sh
sudo systemctl daemon-reload
sudo systemctl start cloudblock-ansible-state.service
sudo systemctl enable cloudblock-ansible-state.timer
sudo systemctl enable cloudblock-ansible-state.service
  FILECONTENT
}

output "cloudblock-output" {
  value = <<OUTPUT

  #############
  ## OUTPUTS ##
  #############
  
  ## SSH ##
  ssh ubuntu@${digitalocean_floating_ip.do-ip.ip_address}
  
  ## WebUI ##
  https://${digitalocean_floating_ip.do-ip.ip_address}/admin/
  
  ## Wireguard Client Files ##
  https://cloud.digitalocean.com/spaces/${var.do_prefix}-bucket-${random_string.do-random.result}?path=wireguard%2F

  ## ##################### ##
  ## Ansible Service Setup ##
  ## ##################### ##
  scp ${var.do_prefix}-setup-${random_string.do-random.result}.sh ubuntu@${digitalocean_floating_ip.do-ip.ip_address}:~/${var.do_prefix}-setup-${random_string.do-random.result}.sh
  ssh ubuntu@${digitalocean_floating_ip.do-ip.ip_address} "chmod +x ${var.do_prefix}-setup-${random_string.do-random.result}.sh && ~/${var.do_prefix}-setup-${random_string.do-random.result}.sh"
  
  ## ################################################ ##
  ## Update Containers and Ansible Rerun Instructions ##
  ## ################################################ ##
  ssh ubuntu@${digitalocean_floating_ip.do-ip.ip_address}
  
  # If updating containers, remove the old containers - this brings down the service until ansible is re-applied.
  sudo docker rm -f cloudflared_doh pihole wireguard web_proxy
  
  # Re-apply Ansible playbook via systemd service
  sudo systemctl start cloudblock-ansible-state.service
  
  ## Destroying ##
  
  # Before terraform destroy, delete all objects from buckets using the aws CLI - this action is irreversible.
  # Install awscli via pip3
  sudo apt update && sudo DEBIAN_FRONTEND=noninteractive apt-get -q -y install python3-pip
  pip3 install --user --upgrade awscli
  # Set credentials
  aws configure set aws_access_key_id ${var.do_storageaccessid}
  aws configure set aws_secret_access_key ${var.do_storagesecretkey}
  # Remove objects
  aws s3 rm --recursive s3://${var.do_prefix}-bucket-${random_string.do-random.result}/ --endpoint https://${var.do_region}.digitaloceanspaces.com
  OUTPUT
}
