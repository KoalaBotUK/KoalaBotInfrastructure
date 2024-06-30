terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.102.0"
    }
  }
}

resource "oci_core_vcn" "vcn" {
  cidr_block     = var.cidr_block
  display_name   = "kb-${var.env}-vcn"
  compartment_id = var.compartment_ocid
}

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "kb-${var.env}-igw"
}

resource "oci_core_subnet" "subnet" {
  cidr_block                 = "10.0.1.0/24"
  vcn_id                     = oci_core_vcn.vcn.id
  compartment_id             = var.compartment_ocid
  display_name               = "kb-${var.env}-subnet"
  prohibit_public_ip_on_vnic = false
  route_table_id             = oci_core_default_route_table.default_route_table.id
  security_list_ids          = [oci_core_default_security_list.default_security_list.id]
}

resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = oci_core_vcn.vcn.default_route_table_id
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
}

resource "oci_core_default_security_list" "default_security_list" {
  manage_default_resource_id = oci_core_vcn.vcn.default_security_list_id

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    protocol = "6" # TCP
    source   = "0.0.0.0/0"
    tcp_options {
      min = 3306
      max = 3306
    }
  }
}
