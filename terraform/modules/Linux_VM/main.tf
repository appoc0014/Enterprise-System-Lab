resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name        = var.vm_name
  description = var.vm_description
  tags        = var.vm_tags
  node_name   = var.target_node
  vm_id       = var.vm_id

  clone {
    vm_id     = var.base_vm_id
    node_name = var.node_name
    full      = var.full_clone
  }

  started = var.started
  on_boot = var.on_boot

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
  }

  network_device {
    bridge  = var.network_bridge
    model   = var.network_model
    vlan_id = var.network_vlan_id
  }

  initialization {
    datastore_id = var.ci_datastore_id

    dynamic "dns" {
      for_each = (var.ci_dns_domain != null || var.ci_dns_servers != null) ? [1] : []
      content {
        domain  = var.ci_dns_domain
        servers = var.ci_dns_servers
      }
    }

    dynamic "user_account" {
      for_each = var.ci_username != null ? [1] : []
      content {
        username = var.ci_username
        keys     = var.ci_ssh_keys
        password = var.ci_password
      }
    }

    ip_config {
      ipv4 {
        address = var.ip_config_ipv4_address
        gateway = var.ip_config_ipv4_address == "dhcp" ? null : var.ip_config_ipv4_gateway
      }
    }
  }

  timeouts = {
    create = "${var.timeout_clone}s"
  }

  lifecycle {
    ignore_changes = [
      # Avoid perpetual diffs on the clone block once the VM exists
      clone,
    ]
  }
}
