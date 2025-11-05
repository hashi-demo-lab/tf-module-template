# GitHub Repository Configuration Guide

This guide walks you through configuring the required GitHub secrets and variables for the module validation and release workflows.

## Required Configuration

### 1. GitHub Secrets (Sensitive Data)

Navigate to: **Settings → Secrets and variables → Actions → Secrets**

Click **"New repository secret"** and add:

#### `TFE_TOKEN`
- **Value**: Your Terraform Cloud API token
- **How to get it**:
  1. Log in to Terraform Cloud (app.terraform.io)
  2. Go to **User Settings → Tokens**
  3. Click **"Create an API token"**
  4. Name it (e.g., "GitHub Actions - Module Publishing")
  5. Copy the token (you won't see it again!)
  6. Paste as the secret value

**Required Permissions**:
- Manage Private Registry modules
- Read/Write access to the organization

---

### 2. GitHub Variables (Non-Sensitive Configuration)

Navigate to: **Settings → Secrets and variables → Actions → Variables**

Click **"New repository variable"** and add each of these:

#### `TFE_ORG`
- **Value**: Your Terraform Cloud organization name
- **Example**: `hashi-demo-lab` or `my-company`
- **Where to find it**: The organization name appears in your TFC URL: `https://app.terraform.io/app/YOUR-ORG-HERE`

#### `TFE_MODULE`
- **Value**: The module name (without provider)
- **Example**: For `terraform-aws-vpc`, use `vpc`
- **Pattern**: `<module-name>` (the middle part of terraform-provider-name)

#### `TFE_PROVIDER`
- **Value**: The provider name
- **Examples**: 
  - `aws` - For AWS resources
  - `azurerm` - For Azure resources
  - `google` - For GCP resources
  - `tfe` - For Terraform Cloud/Enterprise resources
  - `kubernetes` - For Kubernetes resources

---

## Quick Setup Checklist

Copy and customize this for your repository:

```bash
# Your specific values (CUSTOMIZE THESE):
TFE_ORG="hashi-demo-lab"           # Your TFC organization
TFE_MODULE="project-team"          # Your module name
TFE_PROVIDER="tfe"                 # Your provider
TFE_TOKEN="<your-api-token>"       # From Terraform Cloud
```

**For the repository**: `terraform-tfe-project-team`

**The full module identifier in TFC will be**:
```
hashi-demo-lab/project-team/tfe
```

**Registry URL will be**:
```
https://app.terraform.io/app/hashi-demo-lab/registry/modules/private/hashi-demo-lab/project-team/tfe
```

---

## Step-by-Step Setup (GitHub UI)

### Setting up Secrets

1. Go to your repository on GitHub
2. Click **Settings** (top navigation)
3. In the left sidebar, click **Secrets and variables** → **Actions**
4. Click the **Secrets** tab
5. Click **New repository secret**
6. Name: `TFE_TOKEN`
7. Secret: Paste your TFC API token
8. Click **Add secret**

### Setting up Variables

1. From the same page, click the **Variables** tab
2. Click **New repository variable**
3. Add each variable:

   **Variable 1:**
   - Name: `TFE_ORG`
   - Value: `hashi-demo-lab` (or your org)
   - Click **Add variable**

   **Variable 2:**
   - Name: `TFE_MODULE`  
   - Value: `project-team` (or your module name)
   - Click **Add variable**

   **Variable 3:**
   - Name: `TFE_PROVIDER`
   - Value: `tfe` (or your provider)
   - Click **Add variable**

---

## Verification

After setting up, verify the configuration:

### Check Variables Are Set
```bash
# The workflow will use these values:
${{ vars.TFE_ORG }}      # Your organization
${{ vars.TFE_MODULE }}   # Your module name
${{ vars.TFE_PROVIDER }} # Your provider

# And this secret:
${{ secrets.TFE_TOKEN }} # Your API token (hidden in logs)
```

### Test the Workflow

1. Create a test PR with a `.tf` file change
2. Add the `semver:patch` label
3. The validation workflow should run successfully
4. Merge the PR
5. The release workflow should:
   - Calculate the new version
   - Publish to TFC registry
   - Show success in the job summary

---

## Common Issues

### Error: "Required environment variables not set"
**Cause**: Variables not configured in GitHub repository settings

**Solution**: Follow the setup steps above to add `TFE_ORG`, `TFE_MODULE`, and `TFE_PROVIDER`

### Error: "401 Unauthorized" 
**Cause**: Invalid or missing `TFE_TOKEN`

**Solution**: 
- Verify the token is correct
- Check the token has required permissions
- Token may have expired - generate a new one

### Error: "Module not found"
**Cause**: Module doesn't exist in TFC registry yet

**Solution**: The first run will create version `0.1.0` automatically

### Error: "403 Forbidden"
**Cause**: Token doesn't have permissions for the organization

**Solution**: 
- Verify you're a member of the TFC organization
- Check token has "Manage Private Registry" permission
- Create a new team token with proper permissions

---

## Module Naming Conventions

The full module identifier follows this pattern:

```
{namespace}/{name}/{provider}
```

**Examples**:

| Module | TFE_ORG | TFE_MODULE | TFE_PROVIDER | Full Path |
|--------|---------|------------|--------------|-----------|
| AWS VPC | `myorg` | `vpc` | `aws` | `myorg/vpc/aws` |
| Azure Network | `myorg` | `network` | `azurerm` | `myorg/network/azurerm` |
| TFE Project | `hashi-demo-lab` | `project-team` | `tfe` | `hashi-demo-lab/project-team/tfe` |
| GCP Compute | `myorg` | `compute` | `google` | `myorg/compute/google` |

**Repository Naming Convention** (recommended):
```
terraform-{provider}-{name}
```

Examples:
- `terraform-aws-vpc`
- `terraform-azurerm-network`
- `terraform-tfe-project-team`

---

## Security Best Practices

### ✅ DO:
- Use repository secrets for `TFE_TOKEN`
- Rotate tokens regularly
- Use organization or team tokens (not personal tokens) for production
- Restrict token permissions to minimum required
- Use environment protection rules for production releases

### ❌ DON'T:
- Commit tokens to code
- Share tokens in chat or email
- Use tokens with broader permissions than needed
- Use personal tokens for organizational modules

---

## Alternative: Using GitHub CLI

You can also set secrets/variables using the GitHub CLI:

```bash
# Set the secret
gh secret set TFE_TOKEN --body "your-token-here"

# Set the variables
gh variable set TFE_ORG --body "hashi-demo-lab"
gh variable set TFE_MODULE --body "project-team"
gh variable set TFE_PROVIDER --body "tfe"

# List to verify
gh secret list
gh variable list
```

---

## For Module Template Users

When creating a new module from the template:

1. **Clone/Create** the new repository
2. **Configure** the 4 values (1 secret + 3 variables)
3. **Update** the repository name to match convention
4. **Push** initial code
5. **Create** first PR with `semver:patch` label
6. **Merge** to publish version `0.1.0`

Each module repository needs its own configuration!

---

## Summary

**You must configure these 4 items in GitHub repository settings:**

| Type | Name | Example Value | Where to Set |
|------|------|---------------|--------------|
| Secret | `TFE_TOKEN` | `********` | Settings → Secrets |
| Variable | `TFE_ORG` | `hashi-demo-lab` | Settings → Variables |
| Variable | `TFE_MODULE` | `project-team` | Settings → Variables |
| Variable | `TFE_PROVIDER` | `tfe` | Settings → Variables |

Without these, the release workflow **will fail** at the "Calculate New Version" step.

---

**Last Updated**: November 2025
