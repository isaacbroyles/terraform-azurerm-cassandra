resource "azurerm_managed_disk" "development1" {
  name                 = "devdisk1"
  location             = "South Central US"
  resource_group_name  = "${azurerm_resource_group.development.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "40"
}

resource "azurerm_virtual_machine" "development1" {
  name                  = "devvm1"
  location              = "South Central US"
  resource_group_name   = "${azurerm_resource_group.development.name}"
  network_interface_ids = ["${azurerm_network_interface.development1.id}"]
  vm_size               = "Standard_A1"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "17.04"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name            = "${azurerm_managed_disk.development1.name}"
    managed_disk_id = "${azurerm_managed_disk.development1.id}"
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = "${azurerm_managed_disk.development1.disk_size_gb}"
  }

  os_profile {
    computer_name  = "development1"
    admin_username = "terraform"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/terraform/.ssh/authorized_keys"
      key_data = "${file("${var.public_key_data}")}"
    }
  }

  provisioner "remote-exec" {
    inline = ["sudo mkdir -p /tmp/provisioning",
      "sudo chown -R terraform:terraform  /tmp/provisioning/"]
    connection {
      host = "${azurerm_public_ip.development1.ip_address}"
      type = "ssh"
      user = "terraform"
      private_key = "${file("${var.private_key_data}")}"
    }
  }

  provisioner "file" {
    source      = "scripts/cassandra/setup_cassandra.sh"
    destination = "/tmp/provisioning/setup_cassandra.sh"
    connection {
      host = "${azurerm_public_ip.development1.ip_address}"
      type = "ssh"
      user = "terraform"
      private_key = "${file("${var.private_key_data}")}"
    }
  }

    provisioner "remote-exec" {
    inline = [
      "sh /tmp/provisioning/setup_cassandra.sh ${azurerm_network_interface.development1.private_ip_address} ${azurerm_network_interface.development1.private_ip_address}"
      ]
    connection {
      host = "${azurerm_public_ip.development1.ip_address}"
      type = "ssh"
      user = "terraform"
      private_key = "${file("${var.private_key_data}")}"
    }
  }
}
