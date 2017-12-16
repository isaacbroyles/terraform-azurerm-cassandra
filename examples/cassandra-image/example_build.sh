#!/bin/bash

packer build -var-file=my-variables.json cassandra.json
