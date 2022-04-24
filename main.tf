terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.88.1"
    }
  }

}
provider "azurerm" {
  features {

  }
}
module "ResourceGroup" {
  source = "./ResourceGroup"
  base_name = "myRG999"
  location = "east US"
}
module "StorageAccount" {
  source = "./StorageAccount"
  base_name = "myRG999"
  resource_group_name = module.ResourceGroup.rg_name_out
  location = "east US"
}