resource "scaleway_instance_ip" "scw-ip" {
}

resource "scaleway_instance_server" "scw-instance" {
  name                              = "${var.scw_prefix}-instance-${random_string.scw-random.result}"
  type                              = var.scw_size
  image                             = var.scw_image
  ip_id                             = scaleway_instance_ip.scw-ip.id
  security_group_id                 = scaleway_instance_security_group.scw-securitygroup.id
  user_data = {
    cloud-init                        = file(local_file.scw_init.filename)
  }
}
