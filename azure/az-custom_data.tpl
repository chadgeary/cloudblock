#!/bin/bash
DNS_SERVER=$(systemd-resolve --status | awk '/DNS Servers/ { print $3 }')
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
pip3 install ansible[azure]
ansible-galaxy collection install azure.azcollection
wget https://raw.githubusercontent.com/ansible-collections/azure/dev/requirements-azure.txt
pip3 install -r requirements-azure.txt
mkdir /opt/cloudblock
git clone ${project_url} /opt/cloudblock/
cd /opt/cloudblock/
git pull
cd playbooks/
ansible-playbook cloudblock_azure.yml --extra-vars 'docker_network=${docker_network} docker_gw=${docker_gw} docker_doh=${docker_doh} docker_pihole=${docker_pihole} docker_wireguard=${docker_wireguard} wireguard_network=${wireguard_network} doh_provider=${doh_provider} dns_novpn=1 ph_prefix=${ph_prefix} ph_suffix=${ph_suffix}' >> /var/log/cloudblock.log
