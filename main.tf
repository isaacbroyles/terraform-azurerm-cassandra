# Configure the Microsoft Azure Provider
provider "azurerm" {}

# Create a resource group
resource "azurerm_resource_group" "development" {
  name     = "development"
  location = "South Central US"
}

resource "azurerm_availability_set" "development" {
  name                = "developmentAvailabilitySet"
  location            = "South Central US"
  resource_group_name = "${azurerm_resource_group.development.name}"
}

# Create a virtual network in the web_servers resource group
resource "azurerm_virtual_network" "network" {
  name                = "devNetwork"
  address_space       = ["10.0.0.0/16"]
  location            = "South Central US"
  resource_group_name = "${azurerm_resource_group.development.name}"
}

resource "azurerm_subnet" "development" {
  name                 = "subnet1"
  resource_group_name  = "${azurerm_resource_group.development.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_public_ip" "development1" {
    name                         = "devPublicIp1"
    location                     = "South Central US"
    resource_group_name          = "${azurerm_resource_group.development.name}"
    public_ip_address_allocation = "static"
}

resource "azurerm_network_security_group" "development" {
    name                = "developmentSecurityGroup"
    location            = "South Central US"
    resource_group_name = "${azurerm_resource_group.development.name}"

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}