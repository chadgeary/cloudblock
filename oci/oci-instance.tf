data "oci_core_image" "ph-image" {
  image_id                = var.oci_imageid
}

data "oci_identity_availability_domain" "ph-availability-domain" {
  compartment_id          = oci_identity_compartment.ph-compartment.id
  ad_number               = var.oci_adnumber
}

data "template_file" "ph-user-data" {
  template                = file("oci-user_data.tpl")
  vars                    = {
    project_url = var.project_url
    docker_network = var.docker_network
    docker_gw = var.docker_gw
    docker_doh = var.docker_doh
    docker_pihole = var.docker_pihole
    docker_wireguard = var.docker_wireguard
    wireguard_network = var.wireguard_network
    doh_provider = var.doh_provider
    dns_novpn = var.dns_novpn
  }
}

resource "oci_core_instance" "ph-instance" {
  compartment_id          = oci_identity_compartment.ph-compartment.id
  availability_domain     = data.oci_identity_availability_domain.ph-availability-domain.name
  display_name            = "${var.ph_prefix}-instance"
  shape                   = var.oci_instance_shape
  availability_config {
    recovery_action         = "RESTORE_INSTANCE"
  }
  create_vnic_details {
    display_name            = "${var.ph_prefix}-nic"
    subnet_id               = oci_core_subnet.ph-subnet.id
  }
  source_details {
    source_id               = data.oci_core_image.ph-image.id
    source_type             = "image"
  }
  metadata = {
    ssh_authorized_keys       = var.ssh_key
    user_data                 = base64encode(data.template_file.ph-user-data.rendered)
  }
} 
