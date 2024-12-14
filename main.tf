provider "proxmox" {
  pm_api_url = "https://192.168.1.138:8006/api2/json"
  pm_user    = "root@pam"
  pm_password = var.proxmox_password
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "debian_template" {
  name        = "debian-11-template"
  target_node = "<your-proxmox-node>"

  clone {
    vm_id = 100  # Replace with an existing VM ID to clone
    full  = true
  }

  os_type = "cloud-init"

  disks {
    size        = 10
    storage     = "local-lvm"
    storage_type = "lvm"
    type        = "scsi"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  cloud_init {
    ipconfig0 = "dhcp"
    user = "root"
    password = "password"
  }

  lifecycle {
    ignore_changes = [cloud_init]
  }
}

output "template_id" {
  value = proxmox_vm_qemu.debian_template.vm_id
}


#resource "null_resource" "convert_to_template" {
 # provisioner "local-exec" {
  #  command = "qm template ${proxmox_vm_qemu.debian_template.vm_id}"
  #}
#}
