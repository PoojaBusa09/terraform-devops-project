resource "virtualbox_vm" "vm" {
  name   = var.vm_name
  image  = "https://app.vagrantup.com/ubuntu/boxes/focal64/versions/20230807.0.0/providers/virtualbox.box"
  cpus   = var.vm_cpus
  memory = var.vm_memory

  network_adapter {
    type = "nat"
  }
}
