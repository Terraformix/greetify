// # Comment out if using a Bastion
resource "azurerm_public_ip" "agent" {
  name                = var.agent_vm_public_ip_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Static"
}


resource "azurerm_network_interface" "agent" {
  name                = "${var.agent_vm_name}-nic"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.agent_vnet.subnet_details[local.agent_vm_subnet_name].id
    private_ip_address_allocation = "Static"
    private_ip_address = "12.0.1.4" # Valid private IP from 12.0.1.0/24 subnet range for the Agent VNet
    public_ip_address_id = azurerm_public_ip.agent.id # Comment out if using a Bastion
  }
  
}

resource "azurerm_linux_virtual_machine" "agent" {
  name                = var.agent_vm_name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  size                = "Standard_DS2_v2"
  admin_username      = var.agent_vm_username
  admin_password = var.agent_vm_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.agent.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  identity {
    type = "SystemAssigned"
  }

  # Use a custom_data script to install prerequisite software instead of Ansinble
  # custom_data = base64encode(file("${path.module}/self-hosted-runner-setup.sh"))

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# data "template_file" "ansible_inventory" {
#   template = <<-EOT
#   [agent]
#   ${azurerm_linux_virtual_machine.agent.name} ansible_ssh_user='${azurerm_linux_virtual_machine.agent.admin_username}' ansible_ssh_common_args='-o StrictHostKeyChecking=no' ansible_host='${azurerm_linux_virtual_machine.agent.public_ip_address}'
#   EOT
# }

# resource "local_file" "ansible_inventory_file" {
#   content  = data.template_file.ansible_inventory.rendered
#   filename = "${path.module}/ansible/inventory.ini"
#   depends_on = [ data.template_file.ansible_inventory ]
# }

# resource "null_resource" "run_ansible" {

#   provisioner "local-exec" {
#     command = "ansible-playbook -i ${path.module}/ansible/inventory.ini  -u ${azurerm_linux_virtual_machine.agent.admin_username} --extra-vars 'ansible_ssh_pass=${azurerm_linux_virtual_machine.agent.admin_password}' ${path.module}/ansible/playbook.yml"
#   }

#   depends_on = [local_file.ansible_inventory_file]

# }

# # Setup self-hosted Github Actions runner on the Agent VM
# resource "null_resource" "github_runner_setup" {
  
#   provisioner "remote-exec" {

#     inline = [
#       "bash ${file("self-hosted-runner-setup.sh")} ${var.gh_actions_runner_registration_token}"
#     ]

#     connection {
#       type        = "ssh"
#       host        = azurerm_linux_virtual_machine.agent.public_ip_address
#       user        = azurerm_linux_virtual_machine.agent.admin_username
#       password = azurerm_linux_virtual_machine.agent.admin_password
#       #private_key = file("~/.ssh/id_rsa")
#     }
#   }
# }
