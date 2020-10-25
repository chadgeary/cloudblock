#!/bin/bash
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
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip git
pip3 install --upgrade ansible
mkdir /opt/cloudblock
git clone ${project_url} /opt/cloudblock/
cd /opt/cloudblock/
git pull
cd playbooks/
ansible-playbook cloudblock_amd64.yml --extra-vars 'docker_network=${docker_network} docker_gw=${docker_gw} docker_doh=${docker_doh} docker_pihole=${docker_pihole} docker_wireguard=${docker_wireguard} wireguard_network=${wireguard_network} doh_provider=${doh_provider} dns_novpn=1' >> /var/log/cloudblock.log
