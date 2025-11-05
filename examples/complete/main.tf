############################################################################################################
# Complete Example
#
# This example demonstrates advanced configuration with all available features enabled.
# Showcases best practices and real-world usage patterns.
############################################################################################################

# Example: Uncomment and customize for your module
# module "example_complete" {
#   source = "../.."  # Points to the root module
#   
#   # Required variables
#   name                = var.name
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   
#   # Optional: Feature flags
#   # enable_private_endpoint = var.enable_private_endpoint
#   # enable_monitoring       = var.enable_monitoring
#   # enable_backup           = var.enable_backup
#   
#   # Optional: Advanced configuration
#   # sku_name = var.sku_name
#   # capacity = var.capacity
#   
#   # Optional: Networking
#   # subnet_id                   = var.subnet_id
#   # private_dns_zone_id         = var.private_dns_zone_id
#   
#   # Optional: Monitoring and diagnostics
#   # log_analytics_workspace_id  = var.log_analytics_workspace_id
#   # diagnostic_settings = {
#     # logs = {
#     #   enabled        = true
#     #   retention_days = 30
#     # }
#     # metrics = {
#     #   enabled        = true
#     #   retention_days = 30
#     # }
#   # }
#   
#   # Optional: Security
#   # key_vault_key_id           = var.key_vault_key_id
#   # managed_identity_ids       = var.managed_identity_ids
#   
#   # Optional: RBAC
#   # role_assignments = var.role_assignments
#   
#   # Optional: Resource lock
#   # lock = {
#   #   kind = "CanNotDelete"
#   #   name = "resource-lock"
#   # }
#   
#   # Tags
#   tags = var.tags
# }
