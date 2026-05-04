resource "local_file" "vm_file" {
  filename = "${path.module}/vm-info.txt"
  content  = "Terraform VM Project is working successfully in Ubuntu VM\n"
}
