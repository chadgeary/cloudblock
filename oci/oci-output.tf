output "ssh-msg" {
  value                   = "ssh via: ssh ubuntu@${oci_core_instance.ph-instance.public_ip}"
}

output "wireguard-msg" {
  value                   = "wireguard configuration files @ https://console.${var.oci_region}.oraclecloud.com/object-storage/buckets/${data.oci_objectstorage_namespace.ph-bucket-namespace.namespace}/${var.ph_prefix}-bucket/objects"
}

output "pihole-web-msg" {
  value                   = "pihole webUI @ https://${oci_core_instance.ph-instance.public_ip}/admin/"
}

output "pihole-web-vpn-msg" {
  value                   = "pihole webUI also available (when on Wireguard VPN) @ https://${var.docker_pihole}/admin/" 
}
