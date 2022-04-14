terraform {

  required_version = ">=0.12"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "resource_group" {
  name     = "TF-group"
  location = "SouthIndia"
}

resource "azurerm_kubernetes_cluster" "terraform_k8s" {
  name                = "example-aks1"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.terraform_k8s.kube_config.0.client_certificate
}

terraform {
   backend "local" {}
 }

output "kube_config" {
  value = azurerm_kubernetes_cluster.terraform_k8s.kube_config_raw

  sensitive = true
}
