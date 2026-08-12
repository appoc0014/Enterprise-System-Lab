module "ubuntu_vm" {
  source   = "modules/Linux_VM"
  for_each = var.vms

  vm_name        = each.key
  vm_description = each.value.vm_description
  target_node    = each.value.target_node
  vm_id          = each.value.vm_id
  vm_cores       = each.value.vm_cores
  vm_sockets     = each.value.vm_sockets
  vm_tags        = each.value.vm_tags

  # Disk
  vm_disk_size    = each.value.vm_disk_size
  vm_disk_storage = each.value.vm_disk_storage

  # Network
  network_model   = each.value.network_model
  network_bridge  = each.value.network_bridge
  network_vlan_id = each.value.network_vlan_id

  # Memory
  vm_memory = each.value.vm_memory

  # Agent / OS
  vm_agent_enabled = true
  vm_os_type       = "l26"

  # Clone
  base_vm_id = each.value.base_vm_id
  node_name  = each.value.node_name
  full_clone = each.value.full_clone

  # Initialization / cloud-init
  ci_datastore_id = each.value.ci_datastore_id
  ci_dns_domain   = each.value.ci_dns_domain
  ci_dns_servers  = each.value.ci_dns_servers
  ci_username     = coalesce(each.value.ci_username, "ubuntu")
  ci_ssh_keys     = length(each.value.ci_ssh_keys) > 0 ? each.value.ci_ssh_keys : [file(var.ssh_public_key)]
  ci_password     = each.value.ci_password

  ip_config_ipv4_address = each.value.ip_config_ipv4_address
  ip_config_ipv4_gateway = each.value.ip_config_ipv4_gateway

  timeout_clone = each.value.timeout_clone
}

module "winserver_vm" {
  source   = "./modules/WinServer_VM"
  for_each = var.win_vms

  vm_name        = each.key
  vm_description = each.value.vm_description
  target_node    = each.value.target_node
  vm_id          = each.value.vm_id
  vm_cores       = each.value.vm_cores
  vm_sockets     = each.value.vm_sockets
  vm_tags        = each.value.vm_tags
  vm_memory      = each.value.vm_memory

  vm_disk_size    = each.value.vm_disk_size
  vm_disk_storage = each.value.vm_disk_storage

  network_bridge  = each.value.network_bridge
  network_vlan_id = each.value.network_vlan_id

  install_iso_file_id  = each.value.install_iso_file_id
  unattend_iso_file_id = each.value.unattend_iso_file_id
}
