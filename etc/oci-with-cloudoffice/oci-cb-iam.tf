resource "oci_identity_dynamic_group" "ph-id-dynamic-group" {
  compartment_id          = data.oci_identity_compartment.ph-root-compartment.id
  name                    = "${var.ph_prefix}-id-dynamic-group"
  description             = "Identity Dynamic Group for Compute Instance in Compartment"
  matching_rule           = "All {instance.compartment.id = '${oci_identity_compartment.ph-compartment.id}'}"
}

resource "oci_identity_policy" "ph-id-storage-policy" {
  compartment_id          = data.oci_identity_compartment.ph-root-compartment.id
  name                    = "${var.ph_prefix}-id-policy"
  description             = "Identity Policy for instance to use object storage encryption"
  statements              = ["Allow dynamic-group ${oci_identity_dynamic_group.ph-id-dynamic-group.name} to use secret-family in compartment id ${oci_identity_compartment.ph-compartment.id} where target.vault.id='${oci_kms_vault.ph-kms-storage-vault.id}'","Allow dynamic-group ${oci_identity_dynamic_group.ph-id-dynamic-group.name} to use vaults in compartment id ${oci_identity_compartment.ph-compartment.id} where target.vault.id='${oci_kms_vault.ph-kms-storage-vault.id}'","Allow dynamic-group ${oci_identity_dynamic_group.ph-id-dynamic-group.name} to use keys in compartment id ${oci_identity_compartment.ph-compartment.id} where target.vault.id='${oci_kms_vault.ph-kms-storage-vault.id}'","Allow dynamic-group ${oci_identity_dynamic_group.ph-id-dynamic-group.name} to manage object-family in compartment id ${oci_identity_compartment.ph-compartment.id} where target.bucket.name='${var.ph_prefix}-bucket'"]
}

resource "oci_identity_policy" "ph-id-disk-policy" {
  compartment_id          = data.oci_identity_compartment.ph-root-compartment.id
  name                    = "${var.ph_prefix}-id-disk-policy"
  description             = "Identity Policy for disk encryption"
  statements              = ["Allow service blockstorage to use keys in compartment id ${oci_identity_compartment.ph-compartment.id} where target.vault.id='${oci_kms_vault.ph-kms-disk-vault.id}'"]
}

resource "oci_identity_policy" "ph-id-storageobject-policy" {
  compartment_id          = data.oci_identity_compartment.ph-root-compartment.id
  name                    = "${var.ph_prefix}-id-storageobject-policy"
  description             = "Identity Policy for objectstorage service"
  statements              = ["Allow service objectstorage-${var.oci_region} to use keys in compartment id ${oci_identity_compartment.ph-compartment.id} where target.vault.id='${oci_kms_vault.ph-kms-storage-vault.id}'"]
}
