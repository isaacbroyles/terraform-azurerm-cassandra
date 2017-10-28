resource "azurerm_public_ip" "development1" {
    name                         = "devPublicIp1"
    location                     = "South Central US"
    resource_group_name          = "${azurerm_resource_group.development.name}"
    public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "development1" {
  name                = "acctni1"
  location            = "South Central US"
  resource_group_name = "${azurerm_resource_group.development.name}"

  ip_configuration {
    name                          = "devconfiguration1"
    subnet_id                     = "${azurerm_subnet.development.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.development1.id}"
  }
}

resource "azurerm_public_ip" "development2" {
    name                         = "devPublicIp2"
    location                     = "South Central US"
    resource_group_name          = "${azurerm_resource_group.development.name}"
    public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "development2" {
  name                = "acctni2"
  location            = "South Central US"
  resource_group_name = "${azurerm_resource_group.development.name}"

  ip_configuration {
    name                          = "devconfiguration1"
    subnet_id                     = "${azurerm_subnet.development.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.development2.id}"
  }
}

resource "azurerm_public_ip" "development3" {
    name                         = "devPublicIp3"
    location                     = "South Central US"
    resource_group_name          = "${azurerm_resource_group.development.name}"
    public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "development3" {
  name                = "acctni3"
  location            = "South Central US"
  resource_group_name = "${azurerm_resource_group.development.name}"

  ip_configuration {
    name                          = "devconfiguration1"
    subnet_id                     = "${azurerm_subnet.development.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.development3.id}"
  }
}