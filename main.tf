# Configure the Microsoft Azure Provider
provider "azurerm" {}

terraform {
  required_version = ">= 0.10.0"
}

# Create a resource group
resource "azurerm_resource_group" "development" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

# Create a virtual network in the web_servers resource group
resource "azurerm_virtual_network" "network" {
  name                = "devNetwork"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.development.name}"
}

resource "azurerm_subnet" "cassandra" {
  name                 = "subnet1"
  resource_group_name  = "${azurerm_resource_group.development.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefix       = "10.0.1.0/24"
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THE CASSANDRA SERVER NODES
# ---------------------------------------------------------------------------------------------------------------------

module "cassandra_servers" {
  # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
  # to a specific version of the modules, such as the following example:
  # source = "git::git@github.com:isaacbroyles/terraform-azurerm-cassandra.git//modules/cassandra-cluster?ref=v0.0.1"
  source = "./modules/cassandra-cluster"

  cluster_name = "${var.cassandra_cluster_name}"
  cluster_size = "${var.num_cassandra_servers}"
  key_data = "${var.key_data}"

  resource_group_name = "${azurerm_resource_group.development.name}"
  storage_account_name = "${var.storage_account_name}"

  location = "${var.location}"
  custom_data = "" #"${data.template_file.custom_data_cassandra.rendered}"
  instance_size = "${var.instance_size}"
  image_id = "${var.image_uri}"
  subnet_id = "${azurerm_subnet.cassandra.id}"
  associate_public_ip_address_load_balancer = true
}