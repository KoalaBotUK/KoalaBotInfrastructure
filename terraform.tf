terraform {

  cloud {
    organization = "KoalaBotUK"

    workspaces {
      project = "KoalaBot"
      tags    = ["source:cli"]
    }
  }

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.102.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "oci" {
  private_key = var.private_key
}

data "oci_identity_availability_domain" "availability_domain" {
  compartment_id = var.compartment_ocid
  ad_number      = var.availability_domain_number
}


module "kb_vcn" {
  source = "./modules/vcn"

  cidr_block       = "10.0.0.0/16"
  env              = var.env_name
  compartment_ocid = var.compartment_ocid

}

module "kb_instance" {
  source = "./modules/instance"

  mariadb_database    = var.mariadb_database
  mariadb_password    = var.mariadb_password
  mariadb_user        = var.mariadb_user
  ssh_authorized_keys = var.ssh_authorized_keys
  subnet_id           = module.kb_vcn.subnet_id
  availability_domain = data.oci_identity_availability_domain.availability_domain.name
  env                 = var.env_name
  compartment_ocid    = var.compartment_ocid
  compute_shape       = var.compute_shape

  run_koala      = var.run_koala
  bot_owner      = var.bot_owner
  discord_token  = var.discord_token
  encrypted      = var.encrypted
  gmail_email    = var.gmail_email
  gmail_password = var.gmail_password
  sqlite_key     = var.sqlite_key
  twitch_secret  = var.twitch_secret
  twitch_token   = var.twitch_token
}