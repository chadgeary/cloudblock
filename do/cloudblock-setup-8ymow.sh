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
# Install ansible
pip3 install --upgrade ansible
# Make the project directory
mkdir -p /opt/git/cloudblock
# Clone project into project directory
git clone https://github.com/chadgeary/cloudblock /opt/git/cloudblock
# Change to directory
cd /opt/git/cloudblock
# Ensure up-to-date
git pull
# Change to playbooks directory
cd playbooks/
# Execute playbook
ansible-playbook cloudblock_do.yml --extra-vars 'docker_network=172.18.0.0 docker_gw=172.18.0.1 docker_doh=172.18.0.2 docker_pihole=172.18.0.3 docker_wireguard=172.18.0.4 docker_webproxy=172.18.0.5 wireguard_network=172.19.0.0 doh_provider=opendns dns_novpn=1 wireguard_peers=20 vpn_traffic=dns do_prefix=cloudblock do_suffix=8ymow ph_password=changeme1 do_region=nyc3 do_storageaccessid=LYBCQBDDA4JD375FZ3RB do_storagesecretkey=11BvPmDpIn5yfBS+Jmgrusyl9J0bPR4KuYcXkkpXPD8' >> /var/log/cloudblock.log
EOM

# Start / Enable cloudblock-ansible-state
sudo chown root:root /opt/cloudblock-ansible-state.sh
sudo chmod 500 /opt/cloudblock-ansible-state.sh
sudo systemctl daemon-reload
sudo systemctl start cloudblock-ansible-state.service
sudo systemctl enable cloudblock-ansible-state.timer
sudo systemctl enable cloudblock-ansible-state.service
