# Cassandra Run Script

This folder contains a script for configuring and running Cassandra on an [Azure](https://azure.microsoft.com/) server. This script has been tested on Ubuntu 17.10. There is a good chance it will work on other flavors of Debian as well.

## Quick start

This script assumes you installed it, plus all of its dependencies (including Cassandra itself), using the [install-cassandra 
module](https://github.com/isaacbroyles/terraform-azurerm-cassandra/tree/master/modules/install-cassandra). The default install path is 
`/opt/cassandra/bin`, so to start Cassandra in server mode, you run:

```
/opt/cassandra/bin/run-cassandra --seeds SEEDS --listen LISTEN_ADDRESS
```

This will:

1. Generate a Cassandra configuration file called `/etc/cassandra/cassandra.yaml` in the Cassandra config dir (default: `/etc/cassandra`).
   See [Cassandra configuration](#cassandra-configuration) for details on what this configuration file will contain and how
   to override it with your own configuration.

Use the `run-cassandra` command as part of [Custom Data](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/classic/inject-custom-data), so that it executes when the Azure Instance is first booting.

See the [main example](https://github.com/isaacbroyles/terraform-azurerm-cassandra/tree/master/MAIN.md) for fully-working sample code.


## Command line Arguments

The `run-cassandra` script accepts the following arguments:

* `--seeds` (required): Specifies the comma-separated list of IP addresses used by gossip for bootstrapping new nodes joining a cluster .
* `--listen` (required): Specifies which IP address to listen for incoming connections on. 

Example:

```
/opt/cassandra/bin/run-cassandra --seeds CASSANDRA_SEEDS --listen CASSANDRA_LISTEN_ADDRESS
```

## Cassandra configuration

`run-cassandra` generates a configuration file for Cassandra called `cassandra.yaml` that tries to figure out reasonable defaults for a Cassandra cluster in Azure. Check out the [Cassandra Configuration Files documentation](http://cassandra.apache.org/doc/latest/configuration/cassandra_config_file.html) for what configuration settings are
available.

### Overriding the configuration

To override the default configuration, simply put your own configuration file in the Cassandra config folder (default: `/etc/cassandra/`).

