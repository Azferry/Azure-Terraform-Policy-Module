terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.29.0"
      configuration_aliases = [
        azurerm.management
      ]
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.7.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
  }

  required_version = ">= 0.15.1"
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  alias           = "management"
  subscription_id = var.subscription_id_management
}
