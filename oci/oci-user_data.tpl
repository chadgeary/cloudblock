#!/bin/bash
# Disable systemd-resolve
DNS_SERVER='169.254.169.254'
DNS_SEARCH=$(grep '^search ' /etc/resolv.conf)
systemctl disable systemd-resolved
systemctl stop systemd-resolved
rm -f /etc/resolv.conf
tee /etc/resolv.conf << EOM
nameserver $DNS_SERVER
options edns0
$DNS_SEARCH
EOM

# Create systemd service unit file
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

# Create systemd timer unit file
tee /etc/systemd/system/cloudblock-ansible-state.timer << EOM
[Unit]
Description=Starts cloudblock ansible state playbook 1min after boot

[Timer]
OnBootSec=1min
Unit=cloudblock-ansible-state.service

[Install]
WantedBy=multi-user.target
EOM

# Create cloudblock-ansible-state script
tee /opt/cloudblock-ansible-state.sh << EOM
#!/bin/bash
# Update package list
apt-get update
# Install pip3 and git
DEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip git
# Pip update pip
pip3 install --upgrade pip
# Install ansible and oci libraries
pip3 install --upgrade ansible cryptography pyOpenssl oci
# And the collection
ansible-galaxy collection install oracle.oci
# Make the project directory
mkdir -p /opt/cloudblock
# Clone the project into project directory
git clone ${project_url} /opt/cloudblock
# Change to directory
cd /opt/cloudblock
# Ensure up-to-date
git pull
# Change to playbooks directory
cd playbooks/
# Execute playbook
ansible-playbook cloudblock_oci.yml --extra-vars 'docker_network=${docker_network} docker_gw=${docker_gw} docker_doh=${docker_doh} docker_pihole=${docker_pihole} docker_wireguard=${docker_wireguard} docker_webproxy=${docker_webproxy} wireguard_network=${wireguard_network} doh_provider=${doh_provider} dns_novpn=1 ph_password_cipher=${ph_password_cipher} oci_kms_endpoint=${oci_kms_endpoint} oci_kms_keyid=${oci_kms_keyid} oci_storage_namespace=${oci_storage_namespace} oci_storage_bucketname=${oci_storage_bucketname} wireguard_peers=${wireguard_peers} vpn_traffic=${vpn_traffic}' >> /var/log/cloudblock.log
EOM

# Start / Enable cloudblock-ansible-state
chmod +x /opt/cloudblock-ansible-state.sh
systemctl daemon-reload
systemctl start cloudblock-ansible-state.timer
systemctl start cloudblock-ansible-state.service
systemctl enable cloudblock-ansible-state.timer
systemctl enable cloudblock-ansible-state.service
