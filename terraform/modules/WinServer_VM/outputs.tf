output "vm_id" {
  description = "The VM ID of the created VM"
  value       = proxmox_virtual_environment_vm.winserver_vm.vm_id
}

output "vm_name" {
  description = "The name of the VM"
  value       = proxmox_virtual_environment_vm.winserver_vm.name
}

output "node_name" {
  description = "The Proxmox node the VM was created on"
  value       = proxmox_virtual_environment_vm.winserver_vm.node_name
}

output "ipv4_addresses" {
  description = "IPv4 addresses reported by the QEMU guest agent. Empty until the agent is installed in-guest and vm_agent_enabled is set to true."
  value       = try(proxmox_virtual_environment_vm.winserver_vm.ipv4_addresses, null)
}

output "mac_addresses" {
  description = "MAC addresses of the VM's network interfaces"
  value       = try(proxmox_virtual_environment_vm.winserver_vm.mac_addresses, null)
}

