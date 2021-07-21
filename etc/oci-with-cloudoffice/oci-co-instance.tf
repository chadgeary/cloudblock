data "oci_core_image" "nc-image" {
  image_id                = var.co_oci_imageid
}

data "oci_identity_availability_domain" "nc-availability-domain" {
  compartment_id          = oci_identity_compartment.nc-compartment.id
  ad_number               = var.oci_adnumber
}

data "template_file" "nc-user-data" {
  template                = file("oci-co-user_data.tpl")
  vars                    = {
    project_url = var.co_project_url
    docker_network = var.co_docker_network
    docker_gw = var.co_docker_gw
    docker_nextcloud = var.co_docker_nextcloud
    docker_db = var.co_docker_db
    docker_webproxy = var.co_docker_webproxy
    docker_onlyoffice = var.co_docker_onlyoffice
    docker_duckdnsupdater  = var.co_docker_duckdnsupdater
    admin_password_cipher = oci_kms_encrypted_data.nc-kms-nc-admin-secret.ciphertext
    db_password_cipher = oci_kms_encrypted_data.nc-kms-nc-db-secret.ciphertext
    oo_password_cipher = oci_kms_encrypted_data.nc-kms-nc-oo-secret.ciphertext
    bucket_user_key_cipher = oci_kms_encrypted_data.nc-kms-bucket-user-key-secret.ciphertext
    bucket_user_id = oci_identity_customer_secret_key.nc-bucker-user-key.id
    oci_kms_endpoint = oci_kms_vault.nc-kms-storage-vault.crypto_endpoint
    oci_kms_keyid = oci_kms_key.nc-kms-storage-key.id
    oci_storage_namespace = data.oci_objectstorage_namespace.nc-bucket-namespace.namespace
    oci_storage_bucketname = "${var.nc_prefix}-bucket"
    oci_region = var.oci_region
    oci_root_compartment = var.oci_root_compartment
    web_port = var.web_port
    oo_port = var.oo_port
    project_directory = var.project_directory
    enable_duckdns         = var.enable_duckdns
    duckdns_domain         = var.duckdns_domain
    duckdns_token          = var.duckdns_token
    letsencrypt_email      = var.letsencrypt_email
  }
}

resource "oci_core_instance" "nc-instance" {
  compartment_id          = oci_identity_compartment.nc-compartment.id
  availability_domain     = data.oci_identity_availability_domain.nc-availability-domain.name
  display_name            = "${var.nc_prefix}-instance"
  shape                   = var.co_oci_instance_shape
  availability_config {
    recovery_action         = "RESTORE_INSTANCE"
  }
  create_vnic_details {
    display_name            = "${var.nc_prefix}-nic"
    subnet_id               = oci_core_subnet.ph-subnet.id
  }
  shape_config {
    memory_in_gbs           = var.co_oci_instance_memgb
    ocpus                   = var.co_oci_instance_ocpus
  }
  source_details {
    source_id               = data.oci_core_image.nc-image.id
    source_type             = "image"
    kms_key_id              = oci_kms_key.nc-kms-disk-key.id
    boot_volume_size_in_gbs = var.co_oci_instance_diskgb
  }
  metadata = {
    ssh_authorized_keys       = var.ssh_key
    user_data                 = base64encode(data.template_file.nc-user-data.rendered)
  }
  depends_on                = [oci_identity_policy.nc-id-instance-policy,oci_identity_policy.nc-id-bucket-policy,oci_identity_policy.nc-id-disk-policy]
} 
