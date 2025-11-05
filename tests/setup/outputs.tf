############################################################################################################
# Test Setup Outputs
#
# These outputs are used by integration tests via run.setup.<output_name>
############################################################################################################

output "random_id" {
  description = "Random ID for unique resource naming"
  value       = random_id.test.hex
}

# Example outputs - uncomment and customize for your module:
# output "resource_group_name" {
#   description = "Name of the test resource group"
#   value       = azurerm_resource_group.test.name
# }

# output "location" {
#   description = "Azure region for test resources"
#   value       = azurerm_resource_group.test.location
# }

# output "virtual_network_id" {
#   description = "ID of the test virtual network"
#   value       = azurerm_virtual_network.test.id
# }

# output "subnet_id" {
#   description = "ID of the test subnet"
#   value       = azurerm_subnet.test.id
# }

# output "log_analytics_workspace_id" {
#   description = "ID of the test Log Analytics workspace"
#   value       = azurerm_log_analytics_workspace.test.id
# }

# output "key_vault_id" {
#   description = "ID of the test Key Vault"
#   value       = azurerm_key_vault.test.id
# }
