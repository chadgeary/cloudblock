output "cloudblock-output" {
  value = <<OUTPUT

  #############
  ## OUTPUTS ##
  #############

  ## SSH (VPN) ##
  ssh ubuntu@${oci_core_instance.ph-instance.public_ip}
  (ssh ubuntu@${var.docker_gw})

  ## WebUI (VPN) ##
  https://${oci_core_instance.ph-instance.public_ip}/admin/
  (https://${var.docker_webproxy}/admin/)

  ## Wireguard Configurations ##
  https://console.${var.oci_region}.oraclecloud.com/object-storage/buckets/${data.oci_objectstorage_namespace.ph-bucket-namespace.namespace}/${var.ph_prefix}-bucket/objects
  
  ## Update / Ansible Rerun Instructions ##
  ssh ubuntu@${oci_core_instance.ph-instance.public_ip}

  # If updating containers, remove the old containers - this brings down the service until ansible is re-applied.
  sudo docker rm -f cloudflared_doh pihole web_proxy wireguard

  # Update project
  cd /opt/cloudblock/
  sudo git pull

  # Re-apply Ansible playbook with custom variables
  cd playbooks/
  sudo su
  ansible-playbook cloudblock_oci.yml --extra-vars 'docker_network=${var.docker_network} docker_gw=${var.docker_gw} docker_doh=${var.docker_doh} docker_pihole=${var.docker_pihole} docker_wireguard=${var.docker_wireguard} docker_webproxy=${var.docker_webproxy} wireguard_network=${var.wireguard_network} doh_provider=${var.doh_provider} dns_novpn=1 ph_password_cipher=${oci_kms_encrypted_data.ph-kms-ph-secret.ciphertext} oci_kms_endpoint=${oci_kms_vault.ph-kms-storage-vault.crypto_endpoint} oci_kms_keyid=${oci_kms_key.ph-kms-storage-key.id} oci_storage_namespace=${data.oci_objectstorage_namespace.ph-bucket-namespace.namespace} oci_storage_bucketname=${var.ph_prefix}-bucket wireguard_peers=${var.wireguard_peers} vpn_traffic=${var.vpn_traffic}'
  OUTPUT
}
