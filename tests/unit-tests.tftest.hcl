# Unit Tests - Fast validation without deploying real resources
# These tests use `command = plan` to validate logic, variable validation,
# and configuration without creating actual cloud resources.

# Top-level variables that tests inherit
variables {
  # Add your common test variables here
  # Example:
  # resource_group_name = "rg-test"
  # location            = "australiaeast"
}

# Example 1: Variable Validation Test
# Tests that invalid input is correctly rejected by validation rules
run "validate_invalid_input" {
  command = plan

  variables {
    # Provide invalid input that should fail validation
    # Example: name = "invalid-name-with-special-chars!@#"
  }

  expect_failures = [
    # var.name,  # Specify which variable should fail validation
  ]
}

# Example 2: Test Default Values
# Verifies that optional variables have correct defaults
run "test_default_values" {
  command = plan

  variables {
    # Only provide required variables
    # Optional variables should use their defaults
  }

  # Uncomment and customize assertions for your module:
  # assert {
  #   condition     = var.enable_feature == false
  #   error_message = "Feature should be disabled by default"
  # }
}

# Example 3: Conditional Logic Test
# Tests that conditional resource creation works correctly
run "test_conditional_resource_created" {
  command = plan

  variables {
    # Set variable that controls conditional resource
    # Example: enable_monitoring = true
  }

  # Uncomment and customize assertions for your module:
  # assert {
  #   condition     = length(azurerm_monitor_diagnostic_setting.this) == 1
  #   error_message = "Diagnostic setting should be created when monitoring enabled"
  # }
}

run "test_conditional_resource_not_created" {
  command = plan

  variables {
    # Set variable that disables conditional resource
    # Example: enable_monitoring = false
  }

  # Uncomment and customize assertions for your module:
  # assert {
  #   condition     = length(azurerm_monitor_diagnostic_setting.this) == 0
  #   error_message = "Diagnostic setting should NOT be created when monitoring disabled"
  # }
}

# Example 4: Output Validation
# Verifies that module outputs are correctly computed
run "test_outputs_are_correct" {
  command = plan

  variables {
    # Provide input values
  }

  # Uncomment and customize assertions for your module:
  # assert {
  #   condition     = output.name == var.name
  #   error_message = "Output name should match input name"
  # }
  
  # assert {
  #   condition     = output.id != ""
  #   error_message = "Resource ID output should not be empty"
  # }
}

# Example 5: Naming Convention Test
# Tests that resource naming follows organizational standards
# Example 5: Naming Convention Test
# Tests that resource naming follows organizational standards
run "test_naming_convention" {
  command = plan

  variables {
    # name = "test-resource-01"
  }

  # Uncomment and customize assertions for your module:
  # assert {
  #   condition     = can(regex("^[a-z0-9]{5,50}$", var.name))
  #   error_message = "Name must be 5-50 lowercase alphanumeric characters"
  # }
}

# Example 6: Tag Merging Test
# Tests that tags are correctly merged (common + custom)
run "test_tag_merging" {
  command = plan

  variables {
    # Common tags
    # tags = {
    #   Environment = "Test"
    #   ManagedBy   = "Terraform"
    # }
  }

  # Uncomment and customize assertions for your module:
  # assert {
  #   condition     = azurerm_resource.this.tags["Environment"] == "Test"
  #   error_message = "Environment tag should be applied"
  # }
  
  # assert {
  #   condition     = azurerm_resource.this.tags["ManagedBy"] == "Terraform"
  #   error_message = "ManagedBy tag should be applied"
  # }
}
