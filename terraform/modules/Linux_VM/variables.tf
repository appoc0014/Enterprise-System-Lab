variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "vm_description" {
  description = "Description of the virtual machine"
  type        = string
  default     = "Managed by Terraform"
}

variable "vm_tags" {
  description = "Tags for the virtual machine"
  type        = list(string)
  default     = ["terraform"]
}

variable "target_node" {
  description = "The Proxmox node where the VM will be created"
  type        = string
}

variable "vm_id" {
  description = "The VM ID for the new VM. Leave null to auto-assign the next available ID."
  type        = number
  default     = null
}

variable "vm_cores" {
  description = "Number of CPU cores for the VM"
  type        = number
  default     = 2
}

variable "vm_sockets" {
  description = "Number of CPU sockets for the VM"
  type        = number
  default     = 1
}

variable "cpu_type" {
  description = "The CPU type for the VM"
  type        = string
  default     = "host"
}

variable "vm_memory" {
  description = "Dedicated memory for the VM in MB"
  type        = number
  default     = 2048
}

variable "vm_agent_enabled" {
  description = "Whether the QEMU guest agent is enabled"
  type        = bool
  default     = true
}

variable "vm_os_type" {
  description = "The guest OS type hint for Proxmox (e.g. l26 for Linux 2.6+ kernels)"
  type        = string
  default     = "l26"
}

variable "started" {
  description = "Whether the VM should be started after creation"
  type        = bool
  default     = true
}

variable "on_boot" {
  description = "Whether the VM should start automatically when the Proxmox host boots"
  type        = bool
  default     = true
}

# --- Disk ---

variable "disk_interface" {
  description = "The disk interface type (e.g. scsi0, virtio0) — must match the source VM's disk"
  type        = string
  default     = "scsi0"
}

variable "vm_disk_size" {
  description = "Size of the VM disk in GB. Must be >= the source disk size."
  type        = number
  default     = 20
}

variable "vm_disk_storage" {
  description = "Datastore (storage) ID to place the disk on"
  type        = string
  default     = null
}

# --- Network ---

variable "network_model" {
  description = "The network device model (e.g. virtio, e1000)"
  type        = string
  default     = "virtio"
}

variable "network_bridge" {
  description = "The network bridge to attach the VM to"
  type        = string
  default     = "vmbr0"
}

variable "network_vlan_id" {
  description = "The VLAN ID for the network interface. Leave null for no tagging."
  type        = number
  default     = null
}

# --- Clone source ---

variable "base_vm_id" {
  description = "The VM ID of the source VM/template to clone from"
  type        = number
}

variable "node_name" {
  description = "The Proxmox node the source VM/template lives on"
  type        = string
}

variable "full_clone" {
  description = "Whether to perform a full clone (true) or linked clone (false)"
  type        = bool
  default     = true
}

# --- Cloud-init ---

variable "ci_datastore_id" {
  description = "Datastore to store the cloud-init drive on"
  type        = string
  default     = "local-lvm"
}

variable "ci_dns_domain" {
  description = "DNS search domain for cloud-init. Leave null to inherit from the source."
  type        = string
  default     = null
}

variable "ci_dns_servers" {
  description = "List of DNS servers for cloud-init. Leave null to inherit."
  type        = list(string)
  default     = null
}

variable "ci_username" {
  description = "Username to configure via cloud-init. Leave null to leave the source's user config untouched."
  type        = string
  default     = null
}

variable "ci_ssh_keys" {
  description = "List of public SSH keys to inject via cloud-init"
  type        = list(string)
  default     = []
}

variable "ci_password" {
  description = "Password to set via cloud-init. Leave null to skip — prefer SSH keys over passwords."
  type        = string
  default     = null
  sensitive   = true
}

variable "ip_config_ipv4_address" {
  description = "IPv4 address in CIDR form (e.g. 192.168.1.50/24), or 'dhcp'"
  type        = string
  default     = "dhcp"
}

variable "ip_config_ipv4_gateway" {
  description = "IPv4 gateway. Ignored when ip_config_ipv4_address is 'dhcp'."
  type        = string
  default     = null
}

variable "timeout_clone" {
  description = "Timeout in seconds for the clone operation"
  type        = number
  default     = 1800
}
