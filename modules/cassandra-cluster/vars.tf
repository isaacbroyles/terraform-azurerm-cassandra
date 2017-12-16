# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "location" {
  description = "The location that the resources will run in (e.g. East US)"
}

variable "resource_group_name" {
  description = "The name of the resource group that the resources for cassandra will run in"
}

variable "subnet_id" {
  description = "The id of the subnet to deploy the cluster into"
}

variable "cluster_name" {
  description = "The name of the Cassandra cluster (e.g. cassandra-stage). This variable is used to namespace all resources created by this module."
}

variable "image_id" {
  description = "The URL of the Image to run in this cluster. Should be an image that had Cassandra installed and configured by the install-cassandra module."
}

variable "instance_size" {
  description = "The size of Azure Instances to run for each node in the cluster (e.g. Standard_A0)."
}

variable "key_data" {
  description = "The SSH public key that will be added to SSH authorized_users on the cassandra instances"
}

variable "custom_data" {
  description = "A Custom Data script to execute while the server is booting. We remmend passing in a bash script that executes the run-cassandra script, which should have been installed in the Cassandra Image by the install-cassandra module."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "instance_tier" {
  description = "Specifies the tier of virtual machines in a scale set. Possible values, standard or basic."
  default     = "standard"
}

variable "computer_name_prefix" {
  description = "The string that the name of each instance in the cluster will be prefixed with"
  default     = "cassandra"
}

variable "admin_user_name" {
  description = "The name of the administrator user for each instance in the cluster"
  default     = "cassandraadmin"
}

variable "cluster_size" {
  description = "The number of nodes to have in the Cassandra cluster. We strongly recommended that you use either 3 or 5."
  default     = 3
}

variable "allowed_ssh_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which the Azure Instances will allow SSH connections"
  type        = "list"
  default     = []
}

variable "associate_public_ip_address_load_balancer" {
  description = "If set to true, create a public IP address with back end pool to allow SSH publically to the instances."
  default     = false
}
