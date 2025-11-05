############################################################################################################
# Test Setup Module
#
# Purpose: Creates shared test resources (fixtures) for integration tests.
# These resources are created once and reused across multiple integration tests.
#
# Common Use Cases:
# - Resource groups for test resources
# - Virtual networks and subnets for networking tests
# - Key vaults for secret management tests
# - Random IDs for unique naming
# - Log Analytics workspaces for monitoring tests
#
# Cost Optimization:
# - Use smallest/cheapest SKUs
# - Deploy to low-cost regions
# - Clean up after tests complete
############################################################################################################

# Random ID for unique resource naming
resource "random_id" "test" {
  byte_length = 4
}

# Example: Resource Group for test resources
# Uncomment and customize for your module:
# resource "azurerm_resource_group" "test" {
#   name     = "rg-test-${random_id.test.hex}"
#   location = var.location
#   
#   tags = {
#     Purpose   = "Integration-Testing"
#     ManagedBy = "Terraform-Tests"
#   }
# }

# Example: Virtual Network for networking tests
# Uncomment if your module requires network resources:
# resource "azurerm_virtual_network" "test" {
#   name                = "vnet-test-${random_id.test.hex}"
#   location            = azurerm_resource_group.test.location
#   resource_group_name = azurerm_resource_group.test.name
#   address_space       = ["10.0.0.0/16"]
# }

# Example: Subnet for private endpoint tests
# Uncomment if your module uses private endpoints:
# resource "azurerm_subnet" "test" {
#   name                 = "snet-test-${random_id.test.hex}"
#   resource_group_name  = azurerm_resource_group.test.name
#   virtual_network_name = azurerm_virtual_network.test.name
#   address_prefixes     = ["10.0.1.0/24"]
# }

# Example: Log Analytics Workspace for diagnostic settings
# Uncomment if your module uses diagnostic settings:
# resource "azurerm_log_analytics_workspace" "test" {
#   name                = "law-test-${random_id.test.hex}"
#   location            = azurerm_resource_group.test.location
#   resource_group_name = azurerm_resource_group.test.name
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
# }

# Example: Key Vault for encryption tests
# Uncomment if your module uses customer-managed keys:
# data "azurerm_client_config" "current" {}
# 
# resource "azurerm_key_vault" "test" {
#   name                       = "kv-test-${random_id.test.hex}"
#   location                   = azurerm_resource_group.test.location
#   resource_group_name        = azurerm_resource_group.test.name
#   tenant_id                  = data.azurerm_client_config.current.tenant_id
#   sku_name                   = "standard"
#   purge_protection_enabled   = true
#   
#   access_policy {
#     tenant_id = data.azurerm_client_config.current.tenant_id
#     object_id = data.azurerm_client_config.current.object_id
#     
#     key_permissions = [
#       "Get", "List", "Create", "Delete", "Purge"
#     ]
#   }
# }
