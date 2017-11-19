#!/bin/bash
# This script is meant to be run in the Custom Data of each Azure Instance while it's booting. The script uses the
# run-cassandra script to configure and start Consul in client mode and then the run-cassandra script to configure and start
# Cassandra in server mode. Note that this script assumes it's running in an Azure Image built from the Packer template in
# examples/cassandra-cassandra-ami/cassandra-cassandra.json.

set -e

# Send the log output from this script to custom-data.log, syslog, and the console
exec > >(tee /var/log/custom-data.log|logger -t custom-data -s 2>/dev/console) 2>&1

# The variables below are filled in via Terraform interpolation
/opt/cassandra/bin/run-cassandra --seeds "${seeds}"