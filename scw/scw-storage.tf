resource "scaleway_object_bucket" "scw-backup-bucket" {
  name                              = "${var.scw_prefix}-backup-bucket-${random_string.scw-random.result}"
  acl                               = "private"
  region                            = var.scw_region
}
