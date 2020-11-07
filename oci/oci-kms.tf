resource "oci_kms_vault" "ph-kms-storage-vault" {
  compartment_id          = oci_identity_compartment.ph-compartment.id
  display_name            = "${var.ph_prefix}-vault-${random_string.ph-random.result}"
  vault_type              = "DEFAULT"
}

resource "oci_kms_key" "ph-kms-storage-key" {
  compartment_id          = oci_identity_compartment.ph-compartment.id
  display_name            = "${var.ph_prefix}-storage-key-${random_string.ph-random.result}"
  management_endpoint     = oci_kms_vault.ph-kms-storage-vault.management_endpoint
  key_shape {
    algorithm               = "AES"
    length                  = 32
  }
  protection_mode         = "SOFTWARE"
}

resource "oci_kms_encrypted_data" "ph-kms-ph-secret" {
  crypto_endpoint         = oci_kms_vault.ph-kms-storage-vault.crypto_endpoint
  key_id                  = oci_kms_key.ph-kms-storage-key.id
  plaintext               = base64encode(var.ph_password)
}

resource "oci_kms_vault" "ph-kms-disk-vault" {
  compartment_id          = oci_identity_compartment.ph-compartment.id
  display_name            = "${var.ph_prefix}-disk-vault-${random_string.ph-random.result}"
  vault_type              = "DEFAULT"
}

resource "oci_kms_key" "ph-kms-disk-key" {
  compartment_id          = oci_identity_compartment.ph-compartment.id
  display_name            = "${var.ph_prefix}-disk-key-${random_string.ph-random.result}"
  management_endpoint     = oci_kms_vault.ph-kms-disk-vault.management_endpoint
  key_shape {
    algorithm               = "AES"
    length                  = 32
  }
  protection_mode         = "SOFTWARE"
}
