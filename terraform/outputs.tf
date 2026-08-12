# Linux VM outputs

output "vm_ids" {
  description = "Map of VM name -> VM ID"
  value       = { for k, m in module.ubuntu_vm : k => m.vm_id }
}

output "vm_ipv4_addresses" {
  description = "Map of VM name -> IPv4 addresses (requires guest agent running)"
  value       = { for k, m in module.ubuntu_vm : k => m.ipv4_addresses }
}

output "vm_mac_addresses" {
  description = "Map of VM name -> MAC addresses"
  value       = { for k, m in module.ubuntu_vm : k => m.mac_addresses }
}

# Windows VM outputs

output "win_vm_ids" {
  description = "Map of Windows VM name -> VM ID"
  value       = { for k, m in module.winserver_vm : k => m.vm_id }
}

output "win_vm_ipv4_addresses" {
  description = "Map of Windows VM name -> IPv4 addresses (empty until guest agent is installed and enabled)"
  value       = { for k, m in module.winserver_vm : k => m.ipv4_addresses }
}
