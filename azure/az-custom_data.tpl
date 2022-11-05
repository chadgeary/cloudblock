#!/bin/bash
### Create systemd service unit file
tee /etc/systemd/system/cloudblock-ansible-state.service << EOM
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

### Create systemd timer unit file
tee /etc/systemd/system/cloudblock-ansible-state.timer << EOM
[Unit]
Description=Starts cloudblock ansible state playbook 1min after boot

[Timer]
OnBootSec=1min
Unit=cloudblock-ansible-state.service

[Install]
WantedBy=multi-user.target
EOM

### Create the script executed by systemd
tee /opt/cloudblock-ansible-state.sh << EOM
#!/bin/bash
# Update package list
apt-get update
# Install pip3 git and python packages
DEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip git
pip3 install --upgrade pip
pip3 install --upgrade ansible[azure] cryptography pyOpenssl
# And the collection
ansible-galaxy collection install azure.azcollection --force
# And the requirements
pip3 install --upgrade -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt
# Make the project directory
mkdir -p /opt/cloudblock
# Clone project
git clone ${project_url} /opt/cloudblock/
# Change to project dir
cd /opt/cloudblock/
# Ensure up-to-date
git pull
# Change to playbooks dir
cd playbooks/
# Execute playbook
ansible-playbook cloudblock_azure.yml --extra-vars 'docker_network=${docker_network} docker_gw=${docker_gw} docker_doh=${docker_doh} docker_pihole=${docker_pihole} docker_wireguard=${docker_wireguard} docker_webproxy=${docker_webproxy} wireguard_network=${wireguard_network} doh_provider=${doh_provider} dns_novpn=1 ph_prefix=${ph_prefix} ph_suffix=${ph_suffix} wireguard_peers=${wireguard_peers} vpn_traffic=${vpn_traffic}' >> /var/log/cloudblock.log
EOM

### Start / Enable cloudoffice-ansible-state
chmod +x /opt/cloudblock-ansible-state.sh
systemctl daemon-reload
systemctl start cloudblock-ansible-state.timer
systemctl start cloudblock-ansible-state.service
systemctl enable cloudblock-ansible-state.timer
systemctl enable cloudblock-ansible-state.service

### Disable systemd-resolve
DNS_SERVER=$(resolvectl | awk -F ': ' '/DNS Servers/ { print $2 }')
DNS_SEARCH=$(grep '^search ' /etc/resolv.conf)
systemctl disable systemd-resolved
systemctl stop systemd-resolved
rm -f /etc/resolv.conf
tee /etc/resolv.conf << EOM
nameserver $DNS_SERVER
options edns0
$DNS_SEARCH
EOM
