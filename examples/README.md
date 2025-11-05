# Module Examples

This directory contains working examples demonstrating how to use this module.

## Available Examples

### Basic (`basic/`)
Minimal configuration demonstrating the simplest use case with only required variables.

**Use this when**: You need a quick start with default settings.

**What it includes**:
- Minimum required variables
- Default feature flags (most features disabled)
- Simple, copy-paste ready configuration

### Complete (`complete/`)
Full-featured configuration showcasing all available options and features.

**Use this when**: You need to understand all capabilities or implement advanced scenarios.

**What it includes**:
- All optional variables configured
- Advanced features enabled
- Real-world patterns and best practices

## How to Use Examples

1. **Navigate to the example directory**:
   ```bash
   cd examples/basic  # or examples/complete
   ```

2. **Customize variables**:
   - Copy `terraform.auto.tfvars.example` to `terraform.auto.tfvars`
   - Edit values for your environment

3. **Initialize Terraform**:
   ```bash
   terraform init
   ```

4. **Review the plan**:
   ```bash
   terraform plan
   ```

5. **Apply the configuration**:
   ```bash
   terraform apply
   ```

6. **View outputs**:
   ```bash
   terraform output
   ```

7. **Clean up when done**:
   ```bash
   terraform destroy
   ```

## Cost Awareness

⚠️ These examples may create resources that incur costs in your cloud provider.

**Best Practices**:
- Review the plan before applying
- Destroy resources when no longer needed
- Use cost estimation tools (Infracost, Azure Pricing Calculator, AWS Pricing Calculator)
- Deploy to dev/test subscriptions, not production

## Customization

Feel free to copy and modify these examples for your specific use case.

**Each example includes**:
- `main.tf` - Module usage and configuration
- `variables.tf` - Input variable definitions
- `outputs.tf` - Useful output values from the module
- `terraform.auto.tfvars.example` - Example variable values (rename to use)

**To create your own**:
1. Copy an existing example directory
2. Rename to describe your use case (e.g., `examples/private-endpoint/`)
3. Customize the configuration
4. Update this README to document the new example