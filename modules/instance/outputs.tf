output "instance_public_ip" {
  value = oci_core_instance.compute.public_ip
}

output "mariadb_root_password" {
  value = random_password.mariadb_root_password.result
}