data "oci_identity_compartment" "ph-root-compartment" {
  id                      = var.oci_root_compartment
}

resource "oci_identity_compartment" "ph-compartment" {
  compartment_id          = data.oci_identity_compartment.ph-root-compartment.id
  description             = "Cloudblock compartment"
  name                    = "${var.ph_prefix}-compartment"
}
