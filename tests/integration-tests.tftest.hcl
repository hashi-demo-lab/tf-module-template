############################################################################################################
# Integration Tests (command = apply)
#
# Purpose: Test actual resource deployment with real API calls.
# These tests DEPLOY resources to validate end-to-end functionality.
#
# When to Use Integration Tests:
# - Verify resources are created correctly in the cloud provider
# - Test resource dependencies and relationships
# - Validate computed values that only exist after creation
# - Confirm provider-specific behaviors
# - Test data source queries against real resources
#
# Cost Awareness:
# - Integration tests create REAL resources that may incur costs
# - Always include cleanup (destroy) after tests
# - Use smallest/cheapest SKUs for testing
# - Consider running in dedicated test subscriptions/accounts
#
# Usage:
# terraform test  # Runs both unit and integration tests
#
# Note: These tests use a setup module to create shared test fixtures.
############################################################################################################

# Setup: Create shared test resources
# This creates resources needed by multiple integration tests
run "setup" {
  command = apply

  module {
    source = "./tests/setup"
  }

  # Uncomment variables needed for your test fixtures:
  # variables {
  #   resource_group_name = "rg-test-integration"
  #   location           = "eastus"
  # }
}

# Integration Test Example 1: Basic Resource Creation
# Tests that the primary resource is created successfully
run "test_resource_creation" {
  command = apply

  variables {
    # Provide required variables using outputs from setup
    # resource_group_name = run.setup.resource_group_name
    # location           = run.setup.location
    # name               = "test-resource-${run.setup.random_id}"
  }

  # Uncomment and customize assertions for your module:
  # assert {
  #   condition     = azurerm_resource.this.name != ""
  #   error_message = "Resource name should be populated"
  # }
  
  # assert {
  #   condition     = azurerm_resource.this.id != ""
  #   error_message = "Resource ID should be populated after creation"
  # }
  
  # assert {
  #   condition     = azurerm_resource.this.provisioning_state == "Succeeded"
  #   error_message = "Resource provisioning should succeed"
  # }
}

# Integration Test Example 2: Output Validation
# Tests that outputs contain correct values after deployment
run "test_outputs_after_apply" {
  command = apply

  variables {
    # Use same variables as previous test
    # resource_group_name = run.setup.resource_group_name
    # location           = run.setup.location
    # name               = "test-resource-${run.setup.random_id}"
  }

  # Uncomment and customize assertions for your module:
  # assert {
  #   condition     = output.resource_id != ""
  #   error_message = "Resource ID output should be populated"
  # }
  
  # assert {
  #   condition     = can(regex("^/subscriptions/.+", output.resource_id))
  #   error_message = "Resource ID should be a valid Azure resource ID"
  # }
  
  # assert {
  #   condition     = output.name == var.name
  #   error_message = "Output name should match input name"
  # }
}

# Integration Test Example 3: Data Source Query
# Tests that data sources can query the created resources
run "test_data_source_query" {
  command = apply

  variables {
    # Use outputs from setup
    # resource_group_name = run.setup.resource_group_name
    # location           = run.setup.location
  }

  # Uncomment and customize assertions for your module:
  # assert {
  #   condition     = data.azurerm_resource.existing.id != ""
  #   error_message = "Data source should find the created resource"
  # }
  
  # assert {
  #   condition     = data.azurerm_resource.existing.location == var.location
  #   error_message = "Data source location should match input location"
  # }
}

# Integration Test Example 4: Conditional Resource (Enabled)
# Tests that conditional resources are created when enabled
run "test_conditional_feature_enabled" {
  command = apply

  variables {
    # resource_group_name        = run.setup.resource_group_name
    # location                   = run.setup.location
    # enable_private_endpoint    = true
    # subnet_id                  = run.setup.subnet_id
  }

  # Uncomment and customize assertions for your module:
  # assert {
  #   condition     = azurerm_private_endpoint.this[0].id != ""
  #   error_message = "Private endpoint should be created when enabled"
  # }
  
  # assert {
  #   condition     = azurerm_private_endpoint.this[0].subnet_id == var.subnet_id
  #   error_message = "Private endpoint should use provided subnet"
  # }
}

# Integration Test Example 5: Conditional Resource (Disabled)
# Tests that conditional resources are NOT created when disabled
run "test_conditional_feature_disabled" {
  command = apply

  variables {
    # resource_group_name        = run.setup.resource_group_name
    # location                   = run.setup.location
    # enable_private_endpoint    = false
  }

  # Uncomment and customize assertions for your module:
  # assert {
  #   condition     = length(azurerm_private_endpoint.this) == 0
  #   error_message = "Private endpoint should NOT be created when disabled"
  # }
}

# Integration Test Example 6: Resource with Tags
# Tests that tags are correctly applied to deployed resources
run "test_tags_applied" {
  command = apply

  variables {
    # resource_group_name = run.setup.resource_group_name
    # location           = run.setup.location
    # name               = "test-tagged-resource"
    # tags = {
    #   Environment = "Test"
    #   Owner       = "Integration-Tests"
    #   ManagedBy   = "Terraform"
    # }
  }

  # Uncomment and customize assertions for your module:
  # assert {
  #   condition     = azurerm_resource.this.tags["Environment"] == "Test"
  #   error_message = "Environment tag should be applied to resource"
  # }
  
  # assert {
  #   condition     = azurerm_resource.this.tags["Owner"] == "Integration-Tests"
  #   error_message = "Owner tag should be applied to resource"
  # }
  
  # assert {
  #   condition     = azurerm_resource.this.tags["ManagedBy"] == "Terraform"
  #   error_message = "ManagedBy tag should be applied to resource"
  # }
}

############################################################################################################
# Additional Integration Test Patterns
############################################################################################################

# Pattern: Test Resource Dependencies
# Use when module creates multiple related resources
# run "test_resource_dependencies" {
#   command = apply
#   
#   variables {
#     # Variables here
#   }
#   
#   assert {
#     condition     = azurerm_child_resource.this.parent_id == azurerm_parent_resource.this.id
#     error_message = "Child resource should reference parent resource ID"
#   }
# }

# Pattern: Test Computed Values
# Use when resource attributes are only known after creation
# run "test_computed_values" {
#   command = apply
#   
#   variables {
#     # Variables here
#   }
#   
#   assert {
#     condition     = azurerm_resource.this.fqdn != ""
#     error_message = "FQDN should be computed after resource creation"
#   }
# }

# Pattern: Test Multiple Resources
# Use when module creates multiple instances of same resource type
# run "test_multiple_resources" {
#   command = apply
#   
#   variables {
#     # subnets = {
#     #   subnet1 = { address_prefix = "10.0.1.0/24" }
#     #   subnet2 = { address_prefix = "10.0.2.0/24" }
#     # }
#   }
#   
#   assert {
#     condition     = length(azurerm_subnet.this) == 2
#     error_message = "Should create 2 subnets"
#   }
# }
