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
  OUTPUT
}
