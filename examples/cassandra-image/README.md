# Cassandra  AMI

This folder shows an example of how to use the [install-cassandra sub-module](https://github.com/isaacbroyles/terraform-azurerm-cassandra/tree/master/modules/install-cassandra) from this Module with [Packer](https://www.packer.io/) to create an 
[Azure Managed Image](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/build-image-with-packer) that has Cassandra installed on top of Ubuntu 16.04.

You can use this Image to deploy a [Cassandra cluster](https://www.cassandraproject.io/) by using the [cassandra-cluster module](https://github.com/isaacbroyles/terraform-azurerm-cassandra/tree/master/modules/cassandra-cluster).

Check out the [main example](https://github.com/isaacbroyles/terraform-azurerm-cassandra/tree/master/MAIN.md) for working sample code. For more info on Cassandra 
installation and configuration, check out the [install-cassandra](https://github.com/isaacbroyles/terraform-azurerm-cassandra/tree/master/modules/install-cassandra) documentation.

## Quick start

To build the Cassandra Azure Image:

1. `git clone` this repo to your computer.
1. Install [Packer](https://www.packer.io/).
1. Configure your Azure credentials by setting the `ARM_SUBSCRIPTION_ID`, `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET` and `ARM_TENANT_ID` environment variables.
1. Update the `variables` section of the `cassandra.json` Packer template to specify the Azure region, Cassandra version.

1. Run `packer build cassandra.json`.

To see how to deploy this image, check out the [main example](https://github.com/isaacbroyles/terraform-azurerm-cassandra/tree/master/MAIN.md).


## Creating your own Packer template for production usage

When creating your own Packer template for production usage, you can copy the example in this folder more or less exactly, except for one change: replace the `file` provisioner with a call to `git clone` in the `shell` provisioner. Instead of:

```json
{
  "provisioners": [{
    "type": "file",
    "source": "{{template_dir}}/../../../terraform-azurerm-cassandra",
    "destination": "/tmp"
  },{
    "type": "shell",
    "inline": [
      "/tmp/terraform-azurerm-cassandra/tree/master/modules/install-cassandra/install-cassandra --version {{user `cassandra_version`}}"
    ],
    "pause_before": "30s"
  }]
}
```

Your code should look more like this:

```json
{
  "provisioners": [{
    "type": "shell",
    "inline": [
      "git clone --branch <MODULE_VERSION> https://github.com/isaacbroyles/terraform-azurerm-cassandra.git /tmp/terraform-cassandra-azure",
      "/tmp/terraform-azurerm-cassandra/tree/master/modules/install-cassandra/install-cassandra --version {{user `cassandra_version`}}"
    ],
    "pause_before": "30s"
  }]
}
```

You should replace `<MODULE_VERSION>` in the code above with the version of this module that you want to use (see the [Releases Page](../../releases) for all available versions). That's because for production usage, you should always use a fixed, known version of this Module, downloaded from the official Git repo. On the other hand, when you're  just experimenting with the module, it's OK to use a local checkout of the Module, uploaded from your own computer.