resource "scaleway_object_bucket" "scw-backup-bucket" {
  name   = "${var.scw_prefix}-backup-bucket-${random_string.scw-random.result}"
  region = var.scw_region
}

resource "scaleway_object_bucket_acl" "scw-backup-bucket" {
  bucket = "${var.scw_prefix}-backup-bucket-${random_string.scw-random.result}"
  acl = "private"
}