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
# add/remove VMs — no need to touch main.tf.
variable "vms" {
  description = "Map of VMs to clone. Key is a short logical name, value is its configuration."
  type = map(object({
    vm_id              = number
    vm_name           = string
    vm_description    = string
    vm_cores           = number
    vm_sockets         = number
    vm_tags            = list(string)
    network_vlan_id    = number
    vm_iso             = string
    vm_tags             = list(string)
    # Network Device
    network_model      = string
    network_bridge     = string
    # Memory
    vm_memory          = number
    # Agent
    vm_agent_enabled   = bool
    # Clone
    base_vm_id         = number
    full_clone         = bool
    node_name          = string
    # Disk
    vm_disk_size       = number
    vm_disk_storage    = string
    # Operating system
    vm_os_type         = string
    # Initialization settings for cloud-init
    ci_datastore_id    = string
    ci_dns_domain      = string
    ci_dns_servers     = list(string)
    ci_username        = string
    ci_ssh_keys        = list(string)
    ci_password        = string
    create = each.value.timeout_clone
  }))

  default = {
    web-01 = {
      node_name          = "Ubuntu_Monitoring"
      vm_id              = 211
      clone_source_vm_id = 104
      cpu_cores          = 2
      memory_dedicated   = 2048
      disk_size          = 28
      ip_address         = "192.168.1.70/24"
      ip_gateway         = "192.168.1.1"
      tags               = ["terraform", "Ubuntu"]
    }
    web-02 = {
      node_name          = "Ubuntu_Apps"
      vm_id              = 212
      clone_source_vm_id = 104
      cpu_cores          = 2
      memory_dedicated   = 2048
      disk_size          = 28
      ip_address         = "192.168.1.71/24"
      ip_gateway         = "192.168.1.1"
      tags               = ["terraform", "Ubuntu"]
    }
    db-01 = {
      node_name          = "Ubuntu _Mgmt"
      vm_id              = 213
      clone_source_vm_id = 104
      cpu_cores          = 2
      memory_dedicated   = 2048
      disk_size          = 28
      ip_address         = "192.168.1.72/24"
      ip_gateway         = "192.168.1.1"
      tags               = ["terraform", "Ubuntu"]
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

    # Datastore file IDs, e.g. "local:iso/WindowsServer2025.iso" and
    # "local:iso/winsrv2025-unattend.iso" — upload both to your Proxmox
    # datastore first, then reference them here.
    install_iso_file_id  = string
    unattend_iso_file_id = string
  }))

  default = {}
}
