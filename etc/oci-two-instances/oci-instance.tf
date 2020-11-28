data "oci_core_image" "ph-image" {
  image_id                = var.oci_imageid
}

data "oci_identity_availability_domain" "ph-availability-domain" {
  compartment_id          = oci_identity_compartment.ph-compartment.id
  ad_number               = var.oci_adnumber
}

data "template_file" "ph-user-data" {
  template                = file("oci-user_data.tpl")
  vars                    = {
    project_url = var.project_url
    docker_network = var.docker_network
    docker_gw = var.docker_gw
    docker_doh = var.docker_doh
    docker_pihole = var.docker_pihole
    docker_wireguard = var.docker_wireguard
    docker_webproxy = var.docker_webproxy
    wireguard_network = var.wireguard_network
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
}

resource "oci_core_instance" "ph-instance" {
  compartment_id          = oci_identity_compartment.ph-compartment.id
  availability_domain     = data.oci_identity_availability_domain.ph-availability-domain.name
  display_name            = "${var.ph_prefix}-instance"
  shape                   = var.oci_instance_shape
  availability_config {
    recovery_action         = "RESTORE_INSTANCE"
  }
  create_vnic_details {
    display_name            = "${var.ph_prefix}-nic"
    subnet_id               = oci_core_subnet.ph-subnet.id
  }
  source_details {
    source_id               = data.oci_core_image.ph-image.id
    source_type             = "image"
    kms_key_id              = oci_kms_key.ph-kms-disk-key.id
  }
  metadata = {
    ssh_authorized_keys       = var.ssh_key
    user_data                 = base64encode(data.template_file.ph-user-data.rendered)
  }
  depends_on                = [oci_identity_policy.ph-id-storage-policy,oci_identity_policy.ph-id-disk-policy]
} 
