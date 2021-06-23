data "oci_objectstorage_namespace" "nc-bucket-namespace" {
  compartment_id          = oci_identity_compartment.nc-compartment.id
}

resource "oci_objectstorage_bucket" "nc-bucket" {
  compartment_id          = oci_identity_compartment.nc-compartment.id
  name                    = "${var.nc_prefix}-bucket"
  namespace               = data.oci_objectstorage_namespace.nc-bucket-namespace.namespace
  kms_key_id              = oci_kms_key.nc-kms-storage-key.id
  access_type             = "NoPublicAccess"
  storage_tier            = "Standard"
  versioning              = "Disabled"
}

resource "oci_objectstorage_bucket" "nc-bucket-data" {
  compartment_id          = oci_identity_compartment.nc-compartment.id
  name                    = "${var.nc_prefix}-bucket-data"
  namespace               = data.oci_objectstorage_namespace.nc-bucket-namespace.namespace
  kms_key_id              = oci_kms_key.nc-kms-storage-key.id
  access_type             = "NoPublicAccess"
  storage_tier            = "Standard"
  versioning              = "Disabled"
}
