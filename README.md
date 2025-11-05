# Terraform Module Template

A production-ready Terraform module template with comprehensive DevOps workflows, testing, and best practices.

## 📋 Features

- ✅ **Complete Testing Framework**: Unit and integration tests with examples
- ✅ **Pre-commit Hooks**: Automatic formatting, validation, and testing before commits
- ✅ **CI/CD Workflows**: GitHub Actions for PR validation and automatic publishing
- ✅ **Terraform Cloud Integration**: Automatic publishing to Private Module Registry
- ✅ **Security Scanning**: Built-in tfsec security checks
- ✅ **Auto-documentation**: terraform-docs integration with automated README updates
- ✅ **Semantic Versioning**: Label-based versioning (semver:major/minor/patch)
- ✅ **Test Fixtures**: Reusable setup module for integration tests

## 🚀 Quick Start

### 1. Use This Template

Click "Use this template" on GitHub or clone it:

```bash
git clone <your-repo-url>
cd <your-module-name>
```

### 2. Customize the Module

Update these files for your specific resource:

- `main.tf` - Your Terraform resources
- `variables.tf` - Input variables
- `outputs.tf` - Output values
- `versions.tf` - Provider requirements
- `tests/unit-tests.tftest.hcl` - Uncomment and customize assertions
- `tests/integration-tests.tftest.hcl` - Uncomment and customize assertions
- `tests/setup/main.tf` - Uncomment test fixtures you need

### 3. Set Up Development Environment

```bash
# Install pre-commit (macOS)
brew install pre-commit

# Install pre-commit hooks
pre-commit install

# Test that everything works
pre-commit run --all-files
```

### 4. Configure CI/CD

Set up these GitHub repository variables and secrets:

**Variables** (Settings → Secrets and variables → Actions → Variables):
- `TFE_ORG` - Your Terraform Cloud organization name
- `TFE_MODULE` - Module name (e.g., "project-team")
- `TFE_PROVIDER` - Provider name (e.g., "tfe", "azurerm", "aws")

**Secrets** (Settings → Secrets and variables → Actions → Secrets):
- `TFE_TOKEN` - Terraform Cloud API token with module publishing permissions

**For Integration Tests** (optional, add if running integration tests in CI/CD):
- Azure: `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_TENANT_ID`, `ARM_SUBSCRIPTION_ID`
- AWS: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
- GCP: `GCP_SERVICE_ACCOUNT_KEY`

### 5. Enable Branch Protection

Settings → Branches → Add rule for `main`:

- ✅ Require a pull request before merging
- ✅ Require status checks to pass (select "Validate_Module" workflow)
- ✅ Require branches to be up to date before merging

## 📖 Development Workflow

### Local Development

```bash
# 1. Create a feature branch
git checkout -b feature/my-new-feature

# 2. Make your changes
# Edit main.tf, variables.tf, outputs.tf, etc.

# 3. Update tests
# Customize tests/unit-tests.tftest.hcl
# Customize tests/integration-tests.tftest.hcl

# 4. Run tests locally
terraform init
terraform test -filter=tests/unit-tests.tftest.hcl        # Fast unit tests only
terraform test                                              # All tests (including integration)

# 5. Stage and commit (pre-commit hooks run automatically)
git add .
git commit -m "feat: add new feature"

# 6. Push to remote
git push origin feature/my-new-feature
```

### Pull Request Workflow

```bash
# 1. Create PR on GitHub
gh pr create --title "Add new feature" --body "Description"

# 2. Add semantic version label
# Go to PR → Add label: semver:patch (or minor/major)

# 3. Wait for validation
# Module_Validate workflow runs automatically:
# - Terraform format check
# - Terraform validation
# - Linting (tflint)
# - Security scan (tfsec)
# - Unit tests
# - terraform-docs (updates README)

# 4. Review and merge
# After approval, merge the PR

# 5. Automatic publishing
# Module Release workflow runs on merge:
# - Calculates new version based on label
# - Publishes to Terraform Cloud Private Module Registry
# - TFC automatically runs all tests
```

## 🧪 Testing Strategy

### Unit Tests (Fast - No Real Deployments)

**Purpose**: Validate logic, variable validation, conditionals, and outputs without creating resources.

**Location**: `tests/unit-tests.tftest.hcl`

**Run**: `terraform test -filter=tests/unit-tests.tftest.hcl`

**When**: 
- Pre-commit hook (automatic)
- CI/CD on every PR
- Local development for fast feedback

**Example patterns**:
- Input validation (test that invalid inputs are rejected)
- Default values (verify optional variables use correct defaults)
- Conditional logic (test resources created/not created based on flags)
- Output validation (verify outputs match expected patterns)

### Integration Tests (Slow - Real Deployments)

**Purpose**: Deploy actual resources to validate end-to-end functionality.

**Location**: `tests/integration-tests.tftest.hcl`

**Run**: `terraform test -filter=tests/integration-tests.tftest.hcl`

**When**:
- Manually before pushing (optional)
- CI/CD on PR merge (optional, if credentials configured)
- Terraform Cloud after module publish (automatic)

**Example patterns**:
- Resource creation (verify resource is deployed correctly)
- Computed values (test attributes only known after creation)
- Resource dependencies (verify relationships between resources)
- Data source queries (test data sources can find created resources)

**Cost Warning**: Integration tests create real resources that may incur costs. Use smallest SKUs and clean up after tests.

### Test Fixtures (Shared Resources)

**Purpose**: Create shared resources (resource groups, vnets, etc.) used across multiple integration tests.

**Location**: `tests/setup/`

**Usage**: Reference in integration tests via `run.setup.<output_name>`

## 📦 Module Structure

```
terraform-<provider>-<name>/
├── main.tf                          # Primary resource configurations
├── variables.tf                     # Input variable definitions
├── outputs.tf                       # Output value definitions
├── versions.tf                      # Terraform/provider version constraints
├── locals.tf                        # Local values (optional)
├── providers.tf                     # Provider configurations (optional)
├── README.md                        # This file (auto-updated by terraform-docs)
├── LICENSE                          # License file
├── .gitignore                       # Version control exclusions
├── .pre-commit-config.yaml          # Pre-commit hook configuration
├── .tflint.hcl                      # TFLint configuration (optional)
├── examples/                        # Usage examples
│   ├── README.md                    # Examples documentation
│   ├── basic/                       # Minimal working example
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── complete/                    # Full-featured example
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── tests/                           # Automated tests
│   ├── unit-tests.tftest.hcl       # Fast validation tests (command=plan)
│   ├── integration-tests.tftest.hcl # Real deployment tests (command=apply)
│   └── setup/                       # Test fixtures
│       ├── main.tf                  # Shared test resources
│       ├── variables.tf
│       ├── outputs.tf
│       └── versions.tf
└── .github/                         # CI/CD workflows
    └── workflows/
        ├── module_validate.yml      # PR validation workflow
        ├── pr_merge.yml             # Automatic publishing workflow
        ├── get_module_version.py    # Version calculation script
        ├── publish_module_version.py # Publishing script
        └── requirements.txt         # Python dependencies
```

## 🏷️ Versioning

This module uses **semantic versioning** with label-based automation:

### Version Labels

Add exactly **one** label to your PR:

- `semver:patch` - Bug fixes, documentation updates (1.0.0 → 1.0.1)
- `semver:minor` - New features, backward-compatible (1.0.0 → 1.1.0)
- `semver:major` - Breaking changes (1.0.0 → 2.0.0)

### Version Calculation

The `pr_merge.yml` workflow automatically:
1. Detects the label on the merged PR
2. Fetches the current version from Terraform Cloud PMR
3. Calculates the new version
4. Publishes to Terraform Cloud
5. TFC automatically runs all tests

### Initial Version

If no version exists in PMR, the first publish creates `1.0.0`.

## 🔒 Security Best Practices

- ✅ **tfsec scanning** - Runs on every PR to detect security issues
- ✅ **Pre-commit hooks** - Catch issues before commit
- ✅ **No hardcoded credentials** - Use environment variables or managed identities
- ✅ **Sensitive outputs** - Mark sensitive outputs with `sensitive = true`
- ✅ **Least privilege** - Request minimum required permissions in README

## 📚 Additional Resources

### Terraform Documentation
- [Terraform Testing](https://developer.hashicorp.com/terraform/language/tests)
- [Module Creation Patterns](https://developer.hashicorp.com/terraform/tutorials/modules/pattern-module-creation)
- [Terraform Cloud Private Registry](https://developer.hashicorp.com/terraform/cloud-docs/registry)

### Tools
- [terraform-docs](https://terraform-docs.io/) - Documentation generator
- [pre-commit](https://pre-commit.com/) - Git hook framework
- [tflint](https://github.com/terraform-linters/tflint) - Terraform linter
- [tfsec](https://github.com/aquasecurity/tfsec) - Security scanner

### Workshops and Guides
- See `terraform-best-practices/workshop/` for detailed guides on:
  - Module design patterns
  - Testing deep dive
  - Module publishing workflow
  - Repository organization

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Commit your changes (`git commit -m 'feat: add new feature'`)
4. Push to the branch (`git push origin feature/my-feature`)
5. Create a Pull Request
6. Add a semantic version label (semver:patch/minor/major)
7. Wait for validation checks to pass
8. Get approval and merge


## 🆘 Support

[Specify support contacts, Slack channels, or issue tracking]

---

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->