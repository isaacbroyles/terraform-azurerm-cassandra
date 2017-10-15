#!/bin/bash
sudo apt-get install -y default-jre
sudo apt-get install -y python
echo "deb http://www.apache.org/dist/cassandra/debian 311x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
curl https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y cassandra
sudo systemctl daemon-reload
sudo systemctl enable cassandra
sudo systemctl start cassandra