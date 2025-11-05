############################################################################################################
# Variables for Complete Example
############################################################################################################

# Required Variables
# variable "name" {
#   type        = string
#   description = "Name of the resource"
#   default     = "example-complete"
# }

# variable "location" {
#   type        = string
#   description = "Azure region"
#   default     = "eastus"
# }

# variable "resource_group_name" {
#   type        = string
#   description = "Resource group name"
#   default     = "rg-example-complete"
# }

# Feature Flags
# variable "enable_private_endpoint" {
#   type        = bool
#   description = "Enable private endpoint"
#   default     = true
# }

# variable "enable_monitoring" {
#   type        = bool
#   description = "Enable monitoring and diagnostics"
#   default     = true
# }

# variable "enable_backup" {
#   type        = bool
#   description = "Enable backup"
#   default     = true
# }

# Advanced Configuration
# variable "sku_name" {
#   type        = string
#   description = "SKU for the resource"
#   default     = "Standard"
# }

# variable "capacity" {
#   type        = number
#   description = "Resource capacity"
#   default     = 2
# }

# Networking
# variable "subnet_id" {
#   type        = string
#   description = "Subnet ID for private endpoint"
#   default     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/virtualNetworks/vnet-example/subnets/snet-private"
# }

# variable "private_dns_zone_id" {
#   type        = string
#   description = "Private DNS zone ID"
#   default     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-network/providers/Microsoft.Network/privateDnsZones/privatelink.example.azure.com"
# }

# Monitoring
# variable "log_analytics_workspace_id" {
#   type        = string
#   description = "Log Analytics workspace ID for diagnostics"
#   default     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-monitoring/providers/Microsoft.OperationalInsights/workspaces/law-example"
# }

# Security
# variable "key_vault_key_id" {
#   type        = string
#   description = "Key Vault key ID for customer-managed encryption"
#   default     = "https://kv-example.vault.azure.net/keys/example-key/00000000000000000000000000000000"
# }

# variable "managed_identity_ids" {
#   type        = list(string)
#   description = "Managed identity IDs"
#   default = [
#     "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-identity/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-example"
#   ]
# }

# RBAC
# variable "role_assignments" {
#   type = map(object({
#     role_definition_name = string
#     principal_id         = string
#   }))
#   description = "Role assignments for the resource"
#   default = {
#     reader = {
#       role_definition_name = "Reader"
#       principal_id         = "00000000-0000-0000-0000-000000000000"
#     }
#   }
# }

# Tags
variable "tags" {
  type        = map(string)
  description = "Resource tags"
  default = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    Owner       = "Platform-Team"
    CostCenter  = "IT-Infrastructure"
    Project     = "Cloud-Migration"
  }
}
