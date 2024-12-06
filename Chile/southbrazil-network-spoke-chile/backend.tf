terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.94.0"
    }
  }
  #  backend "local" {
  #  }

  backend "azurerm" {
    resource_group_name  = "la-brs-prod-rg-terraform"
    storage_account_name = "stmpaterraform"
    container_name       = "tfstate"
    key                  = "terraform-cra-chile-brs-prod.tfstate"
  }


}


