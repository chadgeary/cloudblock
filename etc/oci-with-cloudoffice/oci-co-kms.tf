resource "oci_kms_vault" "nc-kms-storage-vault" {
  compartment_id          = oci_identity_compartment.nc-compartment.id
  display_name            = "${var.nc_prefix}-vault-${random_string.nc-random.result}"
  vault_type              = "DEFAULT"
}

resource "oci_kms_key" "nc-kms-storage-key" {
  compartment_id          = oci_identity_compartment.nc-compartment.id
  display_name            = "${var.nc_prefix}-storage-key-${random_string.nc-random.result}"
  management_endpoint     = oci_kms_vault.nc-kms-storage-vault.management_endpoint
  key_shape {
    algorithm               = "AES"
    length                  = 32
  }
  protection_mode         = "SOFTWARE"
}

resource "oci_kms_encrypted_data" "nc-kms-nc-admin-secret" {
  crypto_endpoint         = oci_kms_vault.nc-kms-storage-vault.crypto_endpoint
  key_id                  = oci_kms_key.nc-kms-storage-key.id
  plaintext               = base64encode(var.admin_password)
}

resource "oci_kms_encrypted_data" "nc-kms-nc-db-secret" {
  crypto_endpoint         = oci_kms_vault.nc-kms-storage-vault.crypto_endpoint
  key_id                  = oci_kms_key.nc-kms-storage-key.id
  plaintext               = base64encode(var.db_password)
}

resource "oci_kms_encrypted_data" "nc-kms-nc-oo-secret" {
  crypto_endpoint         = oci_kms_vault.nc-kms-storage-vault.crypto_endpoint
  key_id                  = oci_kms_key.nc-kms-storage-key.id
  plaintext               = base64encode(var.oo_password)
}

resource "oci_kms_encrypted_data" "nc-kms-bucket-user-key-secret" {
  crypto_endpoint         = oci_kms_vault.nc-kms-storage-vault.crypto_endpoint
  key_id                  = oci_kms_key.nc-kms-storage-key.id
  plaintext               = base64encode(oci_identity_customer_secret_key.nc-bucker-user-key.key)
}

resource "oci_kms_vault" "nc-kms-disk-vault" {
  compartment_id          = oci_identity_compartment.nc-compartment.id
  display_name            = "${var.nc_prefix}-disk-vault-${random_string.nc-random.result}"
  vault_type              = "DEFAULT"
}

resource "oci_kms_key" "nc-kms-disk-key" {
  compartment_id          = oci_identity_compartment.nc-compartment.id
  display_name            = "${var.nc_prefix}-disk-key-${random_string.nc-random.result}"
  management_endpoint     = oci_kms_vault.nc-kms-disk-vault.management_endpoint
  key_shape {
    algorithm               = "AES"
    length                  = 32
  }
  protection_mode         = "SOFTWARE"
}
