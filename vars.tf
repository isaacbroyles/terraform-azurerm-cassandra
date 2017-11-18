variable "public_key_data" { default =  "" }
variable "private_key_data" { default = "" }

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ---------------------------------------------------------------------------------------------------------------------

# variable "subscription_id" {
#   description = "The Azure subscription ID"
# }

# variable "tenant_id" {
#   description = "The Azure tenant ID"
# }

# variable "client_id" {
#   description = "The Azure client ID"
# }

# variable "secret_access_key" {
#   description = "The Azure secret access key"
# }

variable "resource_group_name" {
  description = "The name of the Azure resource group cassandra will be deployed into. This RG should already exist"
}

variable "storage_account_name" {
  description = "The name of an Azure Storage Account. This SA should already exist"
}

# variable "storage_account_key" {
#   description = "The key for storage_account_name."
# }

variable "image_uri" {
  description = "The URI to the Azure image that should be deployed to the cassandra cluster."
}

variable "key_data" {
  description = "The SSH public key that will be added to SSH authorized_users on the cassandra instances"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "location" {
  description = "The Azure region the cassandra cluster will be deployed in"
  default = "South Central US"
}

variable "address_space" {
  description = "The supernet for the resources that will be created"
  default = "10.0.0.0/16"
}

variable "subnet_address" {
  description = "The subnet that cassandra resources will be deployed into"
  default = "10.0.10.0/24"
}

variable "cassandra_cluster_name" {
  description = "What to name the Cassandra cluster and all of its associated resources"
  default = "cassandra-example"
}

variable "instance_size" {
  description = "The instance size for the servers"
  default = "Standard_A1"
}

variable "num_cassandra_servers" {
  description = "The number of Cassandra server nodes to deploy. We strongly recommend using 3 or 5."
  default = 3
}
