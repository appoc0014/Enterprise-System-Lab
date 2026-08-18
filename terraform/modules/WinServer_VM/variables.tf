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
  default     = ["terraform", "windows"]
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
  default     = 4
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
  default     = 4096
}

variable "vm_os_type" {
  description = "Guest OS type hint for Proxmox. Windows Server 2025 (and Windows 11-generation kernels) use 'win11'."
  type        = string
  default     = "win11"
}

variable "vm_agent_enabled" {
  description = "Whether to tell Proxmox the QEMU guest agent is enabled. Leave false until you've installed the agent inside Windows post-install, otherwise Terraform will wait on a heartbeat that never arrives."
  type        = bool
  default     = false
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

# --- Disk (SATA, no extra drivers needed) ---

variable "disk_interface" {
  description = "Disk interface. SATA needs no driver injection during install, unlike VirtIO."
  type        = string
  default     = "sata0"
}

variable "vm_disk_size" {
  description = "Size of the VM disk in GB"
  type        = number
  default     = 60
}

variable "vm_disk_storage" {
  description = "Datastore (storage) ID to place the disk on"
  type        = string
}

# --- Network (e1000, no extra drivers needed) ---

variable "network_model" {
  description = "Network device model. e1000 has in-box Windows driver support, unlike virtio."
  type        = string
  default     = "e1000"
}

variable "network_bridge" {
  description = "The network bridge to attach the VM to"
  type        = string
  default     = "vmbr0"
}

variable "network_vlan_id" {
  description = "VLAN ID for the network interface. Leave null for no tagging."
  type        = number
  default     = null
}

# --- Install media ---

variable "install_iso_file_id" {
  description = "Proxmox datastore file ID of the Windows Server install ISO, with autounattend.xml already baked into its root (bpg/proxmox only supports one cdrom device per VM, so the answer file can't be attached as a separate ISO). E.g. 'local:iso/WinServer2025-unattended.iso'"
  type        = string
}

variable "boot_order" {
  description = "Boot device order. Disk first, CD-ROM second: on first boot the disk is empty (no boot record), so BIOS falls through to the CD-ROM and Setup starts normally. Once Setup writes a boot record to disk (early in install, before the first reboot), every later boot goes straight to disk instead of re-launching the installer — CD-first here causes an infinite reinstall loop."
  type        = list(string)
  default     = ["sata0", "ide2"]
}

variable "timeout_create" {
  description = "Timeout in seconds for the initial VM creation (not the unattended install itself, which happens post-boot)"
  type        = number
  default     = 1800
}

