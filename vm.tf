resource "azurerm_network_interface" "development" {
  name                = "acctni"
  location            = "South Central US"
  resource_group_name = "${azurerm_resource_group.development.name}"

  ip_configuration {
    name                          = "devconfiguration1"
    subnet_id                     = "${azurerm_subnet.development.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.development1.id}"
  }
}

resource "azurerm_managed_disk" "development" {
  name                 = "devdisk1"
  location             = "South Central US"
  resource_group_name  = "${azurerm_resource_group.development.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "40"
}

resource "azurerm_virtual_machine" "development" {
  name                  = "devvm1"
  location              = "South Central US"
  resource_group_name   = "${azurerm_resource_group.development.name}"
  network_interface_ids = ["${azurerm_network_interface.development.id}"]
  vm_size               = "Standard_A1"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

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
    name            = "${azurerm_managed_disk.development.name}"
    managed_disk_id = "${azurerm_managed_disk.development.id}"
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = "${azurerm_managed_disk.development.disk_size_gb}"
  }

  os_profile {
    computer_name  = "development"
    admin_username = "terraform"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/terraform/.ssh/authorized_keys"
      key_data = "${file("${var.key_data}")}"
    }
  }
}