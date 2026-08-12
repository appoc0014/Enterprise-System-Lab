terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.70"
    }
  }
}

# NOTE: No `provider "proxmox" {}` block here on purpose.
# Terraform does not allow a module to declare its own provider
# configuration when that module is called with for_each (or count) —
# this module inherits the provider configuration from the root module.
