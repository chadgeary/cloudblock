resource "digitalocean_spaces_bucket" "do-bucket" {
  name   = "${var.do_prefix}-bucket-${random_string.do-random.result}"
  region = var.do_region
  versioning {
    enabled = "false"
  }
}
