resource "oci_identity_dynamic_group" "ph-id-dynamic-group" {
  compartment_id          = data.oci_identity_compartment.ph-root-compartment.id
  name                    = "${var.ph_prefix}-id-dynamic-group"
  description             = "Identity Dynamic Group for Compute Instance in Compartment"
  matching_rule           = "All {instance.compartment.id = '${oci_identity_compartment.ph-compartment.id}'}"
}

resource "oci_identity_policy" "ph-id-policy" {
  compartment_id          = data.oci_identity_compartment.ph-root-compartment.id
  name                    = "${var.ph_prefix}-id-policy"
  description             = "Identity Policy for Access to Compartment Encrypted Data"
  statements              = ["Allow dynamic-group ${oci_identity_dynamic_group.ph-id-dynamic-group.name} to use secret-family in compartment id ${oci_identity_compartment.ph-compartment.id} where target.vault.id='${oci_kms_vault.ph-kms-vault.id}'"]
}
