# Cassandra Install Script

This folder contains a script for installing Cassandra and its dependencies. You can use this script, along with the
[run-cassandra script](https://github.com/hashicorp/terraform-azurerm-cassandra/tree/master/modules/run-cassandra) it installs, to create a Cassandra [Azure Managed Image 
](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/build-image-with-packer) that can be deployed in 
[Azure](https://azure.microsoft.com/) across an Scale Set using the [cassandra-cluster module](https://github.com/hashicorp/terraform-azurerm-cassandra/tree/master/modules/cassandra-cluster).

This script has been tested on Ubuntu 17.10. There is a good chance it will work on other flavors of Debian as well.

## Quick start

To install Cassandra, use `git` to clone this repository and run the `install-cassandra` script:

```
git clone --branch <VERSION> https://github.com/isaacbroyles/terraform-azurerm-cassandra.git
terraform-azurerm-cassandra/modules/install-cassandra/install-cassandra --series 311x
```

The `install-cassandra` script will install Cassandra, its dependencies, and the [run-cassandra script](https://github.com/hashicorp/terraform-azurerm-cassandra/tree/master/modules/run-cassandra).
You can then run the `run-cassandra` script when the server is booting to start Cassandra.

Run the `install-cassandra` script as part of a [Packer](https://www.packer.io/) template to create a Cassandra [Azure Managed Image](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/build-image-with-packer) (see the [cassandra-image example](https://github.com/hashicorp/terraform-azurerm-cassandra/tree/master/examples/cassandra-image) for sample code). You can then deploy the Azure Image across a Scale Set  (see the [main example](https://github.com/hashicorp/terraform-azurerm-cassandra/tree/master/MAIN.md) for fully-working sample code).

## Command line Arguments

The `install-cassandra` script accepts the following arguments:

* `series SERIES`: Install latest Cassandra from series SERIES. Required. 

Example:

```
install-cassandra --series 311x
```

## How it works

The `install-cassandra` script does the following:

1. [Install Cassandra dependencies](#install-cassandra-dependencies)
1. [Install Cassandra binaries and scripts](#install-cassandra-binaries-and-scripts)

### Install Cassandra dependencies

* `apt sources.list`: Add cassandra sources to apt sources list 
* `apt-key`: Add the Apache Cassandra repository keys

### Install Cassandra binaries and scripts

Install the following:

* `cassandra`: Installs the latest version of Cassandra from the specified series using apt-get
* `run-cassandra`: Copy the [run-cassandra script](https://github.com/hashicorp/terraform-azurerm-cassandra/tree/master/modules/run-cassandra) into `/opt/Cassandra/bin`. 


### Follow-up tasks

After the `install-cassandra` script finishes running, you may wish to do the following:

1. If you have custom Cassandra config (`.yaml`) files, you may want to copy them into the config directory (default:
   `/etc/cassandra/`).
   