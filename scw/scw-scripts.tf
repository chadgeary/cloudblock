resource "local_file" "scw_init" {
  filename                          = "${var.scw_prefix}-init-${random_string.scw-random.result}.yml"
  content                           = <<FILECONTENT
#cloud-config for cloudblock on scw (scaleway)
runcmd:
  - [ bash, -c, "DNS_SERVER=$(systemd-resolve --status | awk '/DNS Servers/ { print $3 }') && DNS_SEARCH=$(grep '^search ' /etc/resolv.conf) ; systemctl disable systemd-resolved ; systemctl stop systemd-resolved ; rm -f /etc/resolv.conf ; echo nameserver $DNS_SERVER > /etc/resolv.conf ; echo options edns0 >> /etc/resolv.conf" ]
  - [ bash, -c, "apt-get update" ]
  - [ bash, -c, "DEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip git" ]
  - [ bash, -c, "pip3 install --upgrade pip && pip3 install --upgrade ansible" ]
  - [ bash, -c, "mkdir -p /opt/git/cloudblock && git clone ${var.project_url} /opt/git/cloudblock; cd /opt/git/cloudblock; git pull" ]
  - [ bash, -c, "cd /opt/git/cloudblock/playbooks/ && ansible-playbook cloudblock_do_bootstrap.yml >> /var/log/cloudblock-bootstrap.log" ]
FILECONTENT
}

resource "local_file" "scw_setup" {
  filename                          = "${var.scw_prefix}-setup-${random_string.scw-random.result}.sh"
  content                           = <<FILECONTENT
# Create systemd service unit file
sudo tee /etc/systemd/system/cloudblock-ansible-state.service << EOM
[Unit]
Description=cloudblock-ansible-state
After=network.target
StartLimitInterval=600
StartLimitBurst=3

[Service]
ExecStart=/opt/cloudblock-ansible-state.sh
Type=simple
Restart=on-failure
RestartSec=5

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
# pip3 update pip
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
ansible-playbook cloudblock_scw.yml --extra-vars 'docker_network=${var.docker_network} docker_gw=${var.docker_gw} docker_doh=${var.docker_doh} docker_pihole=${var.docker_pihole} docker_wireguard=${var.docker_wireguard} docker_webproxy=${var.docker_webproxy} wireguard_network=${var.wireguard_network} doh_provider=${var.doh_provider} dns_novpn=${var.dns_novpn} wireguard_peers=${var.wireguard_peers} vpn_traffic=${var.vpn_traffic} scw_prefix=${var.scw_prefix} scw_suffix=${random_string.scw-random.result} ph_password=${var.ph_password} scw_region=${var.scw_region} scw_accesskey=${var.scw_accesskey} scw_secretkey=${var.scw_secretkey} backup_endpoint=${scaleway_object_bucket.scw-backup-bucket.endpoint}' >> /var/log/cloudblock.log
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
