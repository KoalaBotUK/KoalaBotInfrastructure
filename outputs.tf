output "instance_public_ip" {
  value = module.kb_instance.instance_public_ip
}

output "mariadb_root_password" {
  value = module.kb_instance.mariadb_root_password
  sensitive = true
}
