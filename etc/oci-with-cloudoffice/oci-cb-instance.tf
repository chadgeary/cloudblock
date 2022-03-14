data "oci_core_image" "ph-image" {
  image_id                = var.cb_oci_imageid
}

data "oci_identity_availability_domain" "ph-availability-domain" {
  compartment_id          = oci_identity_compartment.ph-compartment.id
  ad_number               = var.oci_adnumber
}

resource "oci_core_instance" "ph-instance" {
  compartment_id          = oci_identity_compartment.ph-compartment.id
  availability_domain     = data.oci_identity_availability_domain.ph-availability-domain.name
  display_name            = "${var.ph_prefix}-instance"
  shape                   = var.cb_oci_instance_shape
  availability_config {
    recovery_action         = "RESTORE_INSTANCE"
  }
  create_vnic_details {
    display_name            = "${var.ph_prefix}-nic"
    subnet_id               = oci_core_subnet.ph-subnet.id
  }
  shape_config {
    memory_in_gbs           = var.cb_oci_instance_memgb
    ocpus                   = var.cb_oci_instance_ocpus
  }
  source_details {
    source_id               = data.oci_core_image.ph-image.id
    source_type             = "image"
    kms_key_id              = oci_kms_key.ph-kms-disk-key.id
    boot_volume_size_in_gbs = var.cb_oci_instance_diskgb
  }
  metadata = {
    ssh_authorized_keys       = var.ssh_key
    user_data                 = base64encode(templatefile(
                                  "oci-cb-user_data.tpl",
                                  {
                                    project_url = var.cb_project_url
                                    docker_network = var.cb_docker_network
                                    docker_gw = var.cb_docker_gw
                                    docker_doh = var.cb_docker_doh
                                    docker_pihole = var.cb_docker_pihole
                                    docker_wireguard = var.cb_docker_wireguard
                                    docker_webproxy = var.cb_docker_webproxy
                                    wireguard_network = var.cb_wireguard_network
                                    doh_provider = var.doh_provider
                                    dns_novpn = var.dns_novpn
                                    ph_password_cipher = oci_kms_encrypted_data.ph-kms-ph-secret.ciphertext
                                    oci_kms_endpoint = oci_kms_vault.ph-kms-storage-vault.crypto_endpoint
                                    oci_kms_keyid = oci_kms_key.ph-kms-storage-key.id
                                    oci_storage_namespace = data.oci_objectstorage_namespace.ph-bucket-namespace.namespace
                                    oci_storage_bucketname = "${var.ph_prefix}-bucket"
                                    wireguard_peers = var.wireguard_peers
                                    vpn_traffic = var.vpn_traffic
                                  }
                                ))
  }
  depends_on                = [oci_identity_policy.ph-id-storage-policy,oci_identity_policy.ph-id-disk-policy]
} 
