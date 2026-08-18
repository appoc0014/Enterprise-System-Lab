variable "proxmox_endpoint" {
  description = "URL of the Proxmox API, e.g. https://proxmox.example.com:8006/"
  type        = string
}

variable "proxmox_insecure" {
  description = "Skip TLS verification (set false once you have a trusted cert)"
  type        = bool
  default     = false
}

variable "proxmox_api_token" {
  description = "Proxmox API token in the form 'user@realm!token-id=uuid'"
  type        = string
  sensitive   = true
}

variable "proxmox_ssh_username" {
  description = "Username used for SSH-based operations against the Proxmox node"
  type        = string
  default     = "root"
}

variable "ssh_public_key" {
  description = "Path to the SSH public key injected into every VM via cloud-init"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

# Everything about each VM lives in this one map. Add/remove entries to
# add/remove VMs — no need to touch main.tf. Field names here match the
# module's variable names 1:1 so the module call in main.tf stays a simple
# each.value.<field> passthrough.
variable "vms" {
  description = "Map of VMs to clone. Key is the VM name, value is its configuration."
  type = map(object({
    target_node    = string
    vm_id          = optional(number)
    vm_description = optional(string, "Managed by Terraform")
    vm_cores       = optional(number, 2)
    vm_sockets     = optional(number, 1)
    vm_memory      = optional(number, 2048)
    vm_tags        = optional(list(string), ["terraform"])

    # Disk
    vm_disk_size    = optional(number, 20)
    vm_disk_storage = optional(string)

    # Network
    network_model   = optional(string, "virtio")
    network_bridge  = optional(string, "vmbr0")
    network_vlan_id = optional(number)

    # Clone source
    base_vm_id = number
    node_name  = string
    full_clone = optional(bool, true)

    # Cloud-init
    ci_datastore_id = optional(string, "local-lvm")
    ci_username     = optional(string)
    ci_ssh_keys     = optional(list(string), [])
    ci_password     = optional(string)
    ci_dns_domain   = optional(string)
    ci_dns_servers  = optional(list(string))

    ip_config_ipv4_address = optional(string, "dhcp")
    ip_config_ipv4_gateway = optional(string)

    timeout_clone = optional(number, 1800)
  }))

  default = {
    LinuxMonitor = {
      target_node    = "DellCluster2"
      vm_id          = 211
      vm_description = "Ubuntu Monitoring"
      vm_cores       = 2
      vm_memory      = 2048
      vm_tags        = ["terraform", "Ubuntu"]

      vm_disk_size    = 40
      vm_disk_storage = "local-lvm"

      base_vm_id = 110
      node_name  = "DellCluster2"

      ip_config_ipv4_address = "192.168.1.70/24"
      ip_config_ipv4_gateway = "192.168.1.1"
    }

    LinuxApps = {
      target_node    = "DellCluster2"
      vm_id          = 212
      vm_description = "Ubuntu Apps"
      vm_cores       = 2
      vm_memory      = 2048
      vm_tags        = ["terraform", "Ubuntu"]

      vm_disk_size    = 40
      vm_disk_storage = "local-lvm"

      base_vm_id = 110
      node_name  = "DellCluster2"

      ip_config_ipv4_address = "192.168.1.71/24"
      ip_config_ipv4_gateway = "192.168.1.1"
    }

    LinuxMgmt = {
      target_node    = "DellCluster2"
      vm_id          = 213
      vm_description = "Ubuntu Mgmt"
      vm_cores       = 2
      vm_memory      = 2048
      vm_tags        = ["terraform", "Ubuntu"]

      vm_disk_size    = 40
      vm_disk_storage = "local-lvm"

      base_vm_id = 110
      node_name  = "DellCluster2"

      ip_config_ipv4_address = "192.168.1.72/24"
      ip_config_ipv4_gateway = "192.168.1.1"
    }
  }
}

# Windows Server VMs — installed fresh from ISO with an unattended answer
# file, not cloned. See modules/WinServer_VM for the resource this drives.
variable "win_vms" {
  description = "Map of Windows Server VMs to create. Key is the VM name, value is its configuration."
  type = map(object({
    target_node    = string
    vm_id          = optional(number)
    vm_description = optional(string, "Managed by Terraform")
    vm_cores       = optional(number, 4)
    vm_sockets     = optional(number, 1)
    vm_memory      = optional(number, 4096)
    vm_tags        = optional(list(string), ["terraform", "windows"])

    vm_disk_size    = optional(number, 60)
    vm_disk_storage = string

    network_bridge  = optional(string, "vmbr0")
    network_vlan_id = optional(number)

    # Datastore file ID of the install ISO, with autounattend.xml already
    # baked into its root (see modules/WinServer_VM for why — bpg/proxmox
    # only supports one cdrom device per VM).
    install_iso_file_id = string
  }))

  default = {}
}

