resource "oci_core_vcn" "ph-vcn" {
  compartment_id               = oci_identity_compartment.ph-compartment.id
  cidr_block                   = var.vcn_cidr
  display_name                 = "${var.ph_prefix}-network"
  dns_label                    = var.ph_prefix
}

resource "oci_core_internet_gateway" "ph-internet-gateway" {
  compartment_id               = oci_identity_compartment.ph-compartment.id
  vcn_id                       = oci_core_vcn.ph-vcn.id
  display_name                 = "${var.ph_prefix}-internet-gateway"
  enabled                      = "true"
}

resource "oci_core_subnet" "ph-subnet" {
  compartment_id               = oci_identity_compartment.ph-compartment.id
  vcn_id                       = oci_core_vcn.ph-vcn.id
  cidr_block                   = var.vcn_cidr
  display_name                 = "${var.ph_prefix}-subnet"
}

resource "oci_core_default_route_table" "ph-route-table" {
  manage_default_resource_id   = oci_core_vcn.ph-vcn.default_route_table_id
  route_rules {
    network_entity_id            = oci_core_internet_gateway.ph-internet-gateway.id
    destination                  = "0.0.0.0/0"
    destination_type             = "CIDR_BLOCK"
  }
}

resource "oci_core_route_table_attachment" "ph-route-table-attach" {
  subnet_id                    = oci_core_subnet.ph-subnet.id
  route_table_id               = oci_core_vcn.ph-vcn.default_route_table_id
}

resource "oci_core_network_security_group" "ph-network-security-group" {
  compartment_id               = oci_identity_compartment.ph-compartment.id
  vcn_id                       = oci_core_vcn.ph-vcn.id
  display_name                 = "${var.ph_prefix}-network-security-group"
}

resource "oci_core_default_security_list" "ph-security-list-nodirectdns" {
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
    }
  }
  ingress_security_rules {
    protocol                     = 6
    source                       = var.mgmt_cidr
    tcp_options {
      max                          = "443"
      min                          = "443"
    }
  }
  ingress_security_rules {
    protocol                     = 17
    source                       = "0.0.0.0/0"
    udp_options {
      max                          = "51820"
      min                          = "51820"
    }
  }
}

resource "oci_core_default_security_list" "ph-security-list-directdns" {
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
    }
  }
  ingress_security_rules {
    protocol                     = 6
    source                       = var.mgmt_cidr
    tcp_options {
      max                          = "443"
      min                          = "443"
    }
  }
  ingress_security_rules {
    protocol                     = 17
    source                       = "0.0.0.0/0"
    udp_options {
      max                          = "51820"
      min                          = "51820"
    }
  }
  ingress_security_rules {
    protocol                     = 6
    source                       = var.mgmt_cidr
    tcp_options {
      max                          = "53"
      min                          = "53"
    }
  }
  ingress_security_rules {
    protocol                     = 17
    source                       = var.mgmt_cidr
    udp_options {
      max                          = "53"
      min                          = "53"
    }
  }
  dynamic ingress_security_rules {
    for_each                     = var.client_cidrs
    content {
      protocol                     = 6
      source                       = ingress_security_rules.value
      tcp_options {
        max                          = "53"
        min                          = "53"
      }
    }
  }
  dynamic ingress_security_rules {
    for_each                     = var.client_cidrs
    content {
      protocol                     = 17
      source                       = ingress_security_rules.value
      udp_options {
        max                          = "53"
        min                          = "53"
      }
    }
  }
}
