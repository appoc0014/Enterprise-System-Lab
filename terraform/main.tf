resource "proxmox_virtual_environment_vm" "winserver_vm" {
  name        = var.vm_name
  description = var.vm_description
  tags        = var.vm_tags
  node_name   = var.target_node
  vm_id       = var.vm_id

  started = var.started
  on_boot = var.on_boot

  # SATA + e1000 need no driver injection, so the installer can see the
  # disk and NIC immediately — that's the whole reason to pick this combo
  # over VirtIO for an unattended install.
  bios    = "seabios"
  machine = "pc"

  cpu {
    cores   = var.vm_cores
    sockets = var.vm_sockets
    type    = var.cpu_type
  }

  memory {
    dedicated = var.vm_memory
  }

  agent {
    enabled = var.vm_agent_enabled
  }

  operating_system {
    type = var.vm_os_type
  }

  disk {
    interface    = var.disk_interface
    size         = var.vm_disk_size
    datastore_id = var.vm_disk_storage
    ssd          = true
  }

  network_device {
    bridge  = var.network_bridge
    model   = var.network_model
    vlan_id = var.network_vlan_id
  }

  # bpg/proxmox only allows a single "cdrom" block per VM (see
  # https://github.com/bpg/terraform-provider-proxmox/issues/718), so the
  # answer file has to be baked into this ISO ahead of time rather than
  # attached as a second CD-ROM. install_iso_file_id should point at a
  # Windows install ISO that already has autounattend.xml at its root
  # (rebuilt with oscdimg — see module README).
  cdrom {
    file_id   = var.install_iso_file_id
    interface = "ide2"
  }

  boot_order = var.boot_order

  timeouts {
    create = "${var.timeout_create}s"
  }

  lifecycle {
    ignore_changes = [
      # Once installed, don't let Terraform keep re-attaching/ejecting
      # install media on every plan.
      cdrom,
    ]
  }
}

