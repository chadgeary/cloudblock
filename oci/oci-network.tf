resource "oci_core_vcn" "ph-vcn" {
  compartment_id               = data.oci_identity_compartment.ph-root-compartment.id
  cidr_block                   = var.vcn_cidr
  display_name                 = "${var.ph_prefix}-network"
  dns_label                    = var.ph_prefix
}

resource "oci_core_subnet" "ph-subnet" {
  compartment_id               = data.oci_identity_compartment.ph-root-compartment.id
  vcn_id                       = oci_core_vcn.ph-vcn.id
  cidr_block                   = var.vcn_cidr
  display_name                 = "${var.ph_prefix}-subnet"
}

resource "oci_core_default_security_list" "ph-security-list" {
  count                        = var.dns_novpn * 0
  manage_default_resource_id   = oci_core_vcn.ph-vcn.default_security_list_id
  display_name                 = "${var.ph_prefix}-security"
  egress_security_rules {
    protocol                     = "all"
    destination                  = "0.0.0.0/0"
  }
  ingress_security_rules {
    protocol                     = 6
    source                       = var.mgmt_cidr
    tcp_options {
      max                          = "22"
      min                          = "22"
      source_port_range {
        max                          = "65535"
        min                          = "1"
      }
    }
  }
  ingress_security_rules {
    protocol                     = 6
    source                       = var.mgmt_cidr
    tcp_options {
      max                          = "443"
      min                          = "443"
      source_port_range {
        max                          = "65535"
        min                          = "1"
      }
    }
  }
  ingress_security_rules {
    protocol                     = 17
    source                       = "0.0.0.0/0"
    udp_options {
      max                          = "51820"
      min                          = "51820"
      source_port_range {
        max                          = "65535"
        min                          = "1"
      }
    }
  }
}

resource "oci_core_default_security_list" "ph-security-list-dns_novpn" {
  count                        = var.dns_novpn * 1
  manage_default_resource_id   = oci_core_vcn.ph-vcn.default_security_list_id
  display_name                 = "${var.ph_prefix}-security"
  egress_security_rules {
    protocol                     = "all"
    destination                  = "0.0.0.0/0"
  }
  ingress_security_rules {
    protocol                     = 6
    source                       = var.mgmt_cidr
    tcp_options {
      max                          = "22"
      min                          = "22"
      source_port_range {
        max                          = "65535"
        min                          = "1"
      }
    }
  }
  ingress_security_rules {
    protocol                     = 6
    source                       = var.mgmt_cidr
    tcp_options {
      max                          = "443"
      min                          = "443"
      source_port_range {
        max                          = "65535"
        min                          = "1"
      }
    }
  }
  ingress_security_rules {
    protocol                     = 17
    source                       = "0.0.0.0/0"
    udp_options {
      max                          = "51820"
      min                          = "51820"
      source_port_range {
        max                          = "65535"
        min                          = "1"
      }
    }
  }
  ingress_security_rules {
    protocol                     = 6
    source                       = var.mgmt_cidr
    tcp_options {
      max                          = "53"
      min                          = "53"
      source_port_range {
        max                          = "65535"
        min                          = "1"
      }
    }
  }
  ingress_security_rules {
    protocol                     = 17
    source                       = var.mgmt_cidr
    udp_options {
      max                          = "53"
      min                          = "53"
      source_port_range {
        max                          = "65535"
        min                          = "1"
      }
    }
  }
}
