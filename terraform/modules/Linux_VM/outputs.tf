output "vm_id" {
  description = "The VM ID of the cloned VM"
  value       = proxmox_virtual_environment_vm.ubuntu_vm.vm_id
}

output "vm_name" {
  description = "The name of the cloned VM"
  value       = proxmox_virtual_environment_vm.ubuntu_vm.name
}

output "node_name" {
  description = "The Proxmox node the VM was created on"
  value       = proxmox_virtual_environment_vm.ubuntu_vm.node_name
}

output "ipv4_addresses" {
  description = "IPv4 addresses reported by the QEMU guest agent (requires vm_agent_enabled = true and the agent running in-guest)"
  value       = try(proxmox_virtual_environment_vm.ubuntu_vm.ipv4_addresses, null)
}

output "mac_addresses" {
  description = "MAC addresses of the VM's network interfaces"
  value       = try(proxmox_virtual_environment_vm.ubuntu_vm.mac_addresses, null)
}
