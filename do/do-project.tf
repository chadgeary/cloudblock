resource "digitalocean_project" "do-project" {
  name        = "${var.do_prefix}-project-${random_string.do-random.result}"
  description = "Nextcloud project for ${var.do_prefix} ${random_string.do-random.result}"
  resources   = [digitalocean_droplet.do-droplet.urn, digitalocean_spaces_bucket.do-bucket.urn]
}
