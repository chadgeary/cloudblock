resource "oci_objectstorage_bucket" "ph-bucket2" {
  compartment_id          = oci_identity_compartment.ph-compartment.id
  name                    = "${var.ph_prefix}-bucket2"
  namespace               = data.oci_objectstorage_namespace.ph-bucket-namespace.namespace
  kms_key_id              = oci_kms_key.ph-kms-storage-key.id
  access_type             = "NoPublicAccess"
  storage_tier            = "Standard"
  versioning              = "Enabled"
}
