# Configure the Microsoft Azure Provider
provider "azurerm" {}

terraform {
  required_version = ">= 0.10.0"
}

# Create a virtual network in the web_servers resource group
resource "azurerm_virtual_network" "network" {
  name                = "cassandravn"
  address_space       = ["${var.address_space}"]
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
}

resource "azurerm_subnet" "cassandra" {
  name                 = "cassandrasubnet"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefix       = "${var.subnet_address}"
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

  resource_group_name = "${var.resource_group_name}"

  location = "${var.location}"
  custom_data = "${data.template_file.user_data_cassandra.rendered}"
  instance_size = "${var.instance_size}"
  image_id = "${var.image_uri}"
  subnet_id = "${azurerm_subnet.cassandra.id}"
  associate_public_ip_address_load_balancer = true
}


# ---------------------------------------------------------------------------------------------------------------------
# THE CUSTOM DATA SCRIPT THAT WILL RUN ON EACH CONSUL SERVER AZURE INSTANCE WHEN IT'S BOOTING
# This script will configure and start Consul
# ---------------------------------------------------------------------------------------------------------------------

data "template_file" "user_data_cassandra" {
  template = "${file("${path.module}/custom-data-cassandra.sh")}"

  vars {
    listen = "${var.listen}"
    seeds = "${var.seeds}"
  }
}
