data "oci_identity_compartment" "nc-root-compartment" {
  id                      = var.oci_root_compartment
}

resource "oci_identity_compartment" "nc-compartment" {
  compartment_id          = data.oci_identity_compartment.nc-root-compartment.id
  description             = "${var.nc_prefix}-compartment"
  name                    = "${var.nc_prefix}-compartment"
}

resource "random_string" "nc-random" {
  length                            = 5
  upper                             = false
  special                           = false
}
