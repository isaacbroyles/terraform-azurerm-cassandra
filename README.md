# terraform-cassandra

## Prerequisites

[Terraform](https://www.terraform.io/) from HashiCorp
[AzureCLI tools](https://github.com/Azure/azure-cli)

## Getting Started

1. ```az login``` - to login to the Azure CLI
  * Follow the terraform guide [here](https://www.terraform.io/docs/providers/azurerm/authenticating_via_azure_cli.html) for more information
2. (optional) Define key_data variable in ```terraform.tfvars```, ```*.auto.tfvars```
  * These files are not checked in to source control to prevent secrets from being shared
3. ```terraform init```
4. ```terraform plan```
5. ```terraform apply```