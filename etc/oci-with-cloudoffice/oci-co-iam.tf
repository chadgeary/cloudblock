resource "oci_identity_dynamic_group" "nc-id-dynamic-group" {
  compartment_id          = data.oci_identity_compartment.nc-root-compartment.id
  name                    = "${var.nc_prefix}-id-dynamic-group"
  description             = "Identity Dynamic Group for Compute Instance in Compartment"
  matching_rule           = "All {instance.compartment.id = '${oci_identity_compartment.nc-compartment.id}'}"
}

resource "oci_identity_policy" "nc-id-instance-policy" {
  compartment_id          = data.oci_identity_compartment.nc-root-compartment.id
  name                    = "${var.nc_prefix}-instance-policy"
  description             = "Identity Policy for instance to use object storage encryption"
  statements              = ["Allow dynamic-group ${oci_identity_dynamic_group.nc-id-dynamic-group.name} to use secret-family in compartment id ${oci_identity_compartment.nc-compartment.id} where target.vault.id='${oci_kms_vault.nc-kms-storage-vault.id}'","Allow dynamic-group ${oci_identity_dynamic_group.nc-id-dynamic-group.name} to use vaults in compartment id ${oci_identity_compartment.nc-compartment.id} where target.vault.id='${oci_kms_vault.nc-kms-storage-vault.id}'","Allow dynamic-group ${oci_identity_dynamic_group.nc-id-dynamic-group.name} to use keys in compartment id ${oci_identity_compartment.nc-compartment.id} where target.vault.id='${oci_kms_vault.nc-kms-storage-vault.id}'","Allow dynamic-group ${oci_identity_dynamic_group.nc-id-dynamic-group.name} to manage object-family in compartment id ${oci_identity_compartment.nc-compartment.id} where target.bucket.name='${var.nc_prefix}-bucket'","Allow dynamic-group ${oci_identity_dynamic_group.nc-id-dynamic-group.name} to read virtual-network-family in compartment id ${oci_identity_compartment.nc-compartment.id}"]
}

resource "oci_identity_policy" "nc-id-disk-policy" {
  compartment_id          = data.oci_identity_compartment.nc-root-compartment.id
  name                    = "${var.nc_prefix}-id-disk-policy"
  description             = "Identity Policy for disk encryption"
  statements              = ["Allow service blockstorage to use keys in compartment id ${oci_identity_compartment.nc-compartment.id} where target.vault.id='${oci_kms_vault.nc-kms-disk-vault.id}'"]
}

resource "oci_identity_policy" "nc-id-storageobject-policy" {
  compartment_id          = data.oci_identity_compartment.nc-root-compartment.id
  name                    = "${var.nc_prefix}-id-storageobject-policy"
  description             = "Identity Policy for objectstorage service"
  statements              = ["Allow service objectstorage-${var.oci_region} to use keys in compartment id ${oci_identity_compartment.nc-compartment.id} where target.vault.id='${oci_kms_vault.nc-kms-storage-vault.id}'","Allow service objectstorage-${var.oci_region} to manage object-family in compartment id ${oci_identity_compartment.nc-compartment.id}"]
}

resource "oci_identity_group" "nc-bucket-group" {
  compartment_id          = data.oci_identity_compartment.nc-root-compartment.id
  description             = "OCI bucket group"
  name                    = "${var.nc_prefix}-bucket-group"
}

resource "oci_identity_user" "nc-bucket-user" {
  compartment_id          = data.oci_identity_compartment.nc-root-compartment.id
  description             = "OCI bucket user"
  name                    = "${var.nc_prefix}-bucket-user"
}

resource "oci_identity_user_group_membership" "nc-bucket-group-membership" {
  group_id                = oci_identity_group.nc-bucket-group.id
  user_id                 = oci_identity_user.nc-bucket-user.id
}

resource "oci_identity_customer_secret_key" "nc-bucker-user-key" {
  display_name            = "${var.nc_prefix}-bucket-user-key"
  user_id                 = oci_identity_user.nc-bucket-user.id
}

resource "oci_identity_policy" "nc-id-bucket-policy" {
  compartment_id          = data.oci_identity_compartment.nc-root-compartment.id
  name                    = "${var.nc_prefix}-bucket-policy"
  description             = "Identity Policy for instance bucket user to use object storage encryption for data bucket"
  statements              = ["Allow group ${oci_identity_group.nc-bucket-group.name} to manage object-family in compartment id ${oci_identity_compartment.nc-compartment.id} where target.bucket.name='${var.nc_prefix}-bucket-data'"]
}
