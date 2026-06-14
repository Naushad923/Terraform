terraform {
  required_providers {
    azurerm={
        source = "hashicorp/azurerm"
        version = "4.77.0"
    }
  }
  backend "azurerm" {
    resource_group_name = "test-rg"
    storage_account_name = "teststorageorcapod"
    container_name = "test-container"
    key = "terraform.tfstate"
    
  }



}

provider "azurerm" {
    features {
      
    }
  
}

resource "azurerm_resource_group" "rg" {
  name = "prod-test-rg"
  location = "westus"
  
}