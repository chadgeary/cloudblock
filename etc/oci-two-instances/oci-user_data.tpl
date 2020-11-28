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
pip3 install --upgrade ansible oci
ansible-galaxy collection install oracle.oci
mkdir /opt/cloudblock
git clone ${project_url} /opt/cloudblock/
cd /opt/cloudblock/
git pull
cd playbooks/
ansible-playbook cloudblock_oci.yml --extra-vars 'docker_network=${docker_network} docker_gw=${docker_gw} docker_doh=${docker_doh} docker_pihole=${docker_pihole} docker_wireguard=${docker_wireguard} docker_webproxy=${docker_webproxy} wireguard_network=${wireguard_network} doh_provider=${doh_provider} dns_novpn=1 ph_password_cipher=${ph_password_cipher} oci_kms_endpoint=${oci_kms_endpoint} oci_kms_keyid=${oci_kms_keyid} oci_storage_namespace=${oci_storage_namespace} oci_storage_bucketname=${oci_storage_bucketname} wireguard_peers=${wireguard_peers} vpn_traffic=${vpn_traffic}' >> /var/log/cloudblock.log
