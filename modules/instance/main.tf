terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = "4.102.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

resource "oci_core_volume" "volume" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = "kb-${var.env}-volume"
  size_in_gbs         = "50"

  lifecycle {
    prevent_destroy = true
  }
}

resource "random_password" "mariadb_root_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "oci_core_instance" "compute" {
  display_name        = "kb-${var.env}-compute"
  compartment_id      = var.compartment_ocid
  availability_domain = var.availability_domain

  shape               = var.compute_shape # Free tier eligible shape
  shape_config {
    ocpus         = 1
    memory_in_gbs = 1
  }
  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = true
  }
  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
    user_data = base64encode(templatefile("${path.module}/scripts/setup.sh",
      {
        motd                  = file("${path.module}/scripts/motd")

        mariadb_root_password = random_password.mariadb_root_password.result
        mariadb_database      = var.mariadb_database
        mariadb_user          = var.mariadb_user
        mariadb_password      = var.mariadb_password

        run_koala = var.run_koala
        bot_owner = var.bot_owner
        discord_token = var.discord_token
        encrypted = var.encrypted
        gmail_email = var.gmail_email
        gmail_password = var.gmail_password
        sqlite_key = var.sqlite_key
        twitch_secret = var.twitch_secret
        twitch_token = var.twitch_token
    }))
  }
  source_details {
    source_type = "image"
    source_id   = "ocid1.image.oc1.uk-london-1.aaaaaaaahklpex67wauy3w6whtyryur53b6fvlzqd3y7fk2tcmkl3gul6kja"
    boot_volume_size_in_gbs = "50"
  }
}

resource "oci_core_volume_attachment" "volume_attachment" {
  #Required
  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.compute.id
  volume_id       = oci_core_volume.volume.id
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_ocid
}

data "oci_core_images" "ubuntu_linux_image" {
  compartment_id           = var.compartment_ocid
#   display_name         = "Canonical Ubuntu 22.04 Minimal aarch64"
  operating_system = "Ubuntu"
  operating_system_version = "22.04"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

