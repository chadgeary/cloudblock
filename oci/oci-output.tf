output "ph-ssh-out" {
  value                   = "ssh via: ssh ubuntu@${oci_core_instance.ph-instance.public_ip}"
}

output "ph-wireguard-out" {
  value                   = "wireguard configuration files @ https://console.${var.oci_region}.oraclecloud.com/object-storage/buckets/${data.oci_objectstorage_namespace.ph-bucket-namespace.namespace}/${var.ph_prefix}-bucket/objects"
}

output "ph-pihole-web-out" {
  value                   = "pihole webUI @ https://${oci_core_instance.ph-instance.public_ip}/admin/"
}
