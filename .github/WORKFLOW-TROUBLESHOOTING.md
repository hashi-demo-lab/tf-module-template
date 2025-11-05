# GitHub Actions Workflow Troubleshooting Guide

This document explains common issues and solutions when working with the module validation and release workflows.

## Common Issues & Solutions

### Issue 1: Workflow Doesn't Run When I Push Code

**Problem**: You push commits to a branch, but the `Module Validate` workflow doesn't trigger.

**Explanation**: This is **expected behavior**. The workflow is configured to run on **Pull Request events**, not direct pushes.

```yaml
on:
  pull_request:
    paths:
      - '**.tf'
      - '**.tfvars'
      - '**.tftest.hcl'
      - '.github/workflows/module_validate.yml'
```

**Solution**: 
1. Push your changes to a feature branch
2. **Create a Pull Request** from your feature branch to `main`
3. The workflow will trigger automatically when the PR is opened or updated

**Manual Trigger**: You can also trigger the workflow manually using the Actions tab via `workflow_dispatch`.

---

### Issue 2: Workflow Doesn't Trigger on PR

**Problem**: You created a PR, but the workflow still doesn't run.

**Root Causes**:

#### A. No Matching Files Changed
The workflow only triggers when specific file types change:
- `**.tf` - Terraform configuration files
- `**.tfvars` - Terraform variables files  
- `**.tftest.hcl` - Terraform test files
- `.github/workflows/module_validate.yml` - The workflow file itself

**Solution**: Ensure your PR includes changes to at least one of these file types.

**Check what files will trigger the workflow:**
```bash
git diff origin/main --name-only | grep -E '\.(tf|tfvars|tftest\.hcl)$'
```

#### B. Workflow Not in Main Branch
GitHub runs workflows based on the **workflow file in the base branch** (main), not the PR branch.

**Solution**: The workflow files must exist in the `main` branch **before** you create the PR.

**Bootstrap Process for New Repos:**
```bash
# 1. Ensure you're on main
git checkout main
git pull origin main

# 2. Copy workflow files from template
cp -r /path/to/template/.github/workflows/* .github/workflows/

# 3. Commit to main
git add .github/workflows/
git commit -m "ci: add GitHub Actions workflows"
git push origin main

# 4. Now create feature branches and PRs
```

#### C. Empty Commits
Empty commits (created with `--allow-empty`) don't change any files, so they don't match the path filters.

**Solution**: Make a real change to a `.tf` file to trigger the workflow.

---

### Issue 3: ".cache" Directory Being Tracked

**Problem**: Git is tracking hundreds of Trivy cache files in `.cache/trivy/`.

**Root Cause**: The `.cache/` directory wasn't in `.gitignore`, so Trivy's local cache got committed.

**Solution**: 
```bash
# 1. Add .cache/ to .gitignore (already done in template)
echo ".cache/" >> .gitignore

# 2. Remove from git tracking
git rm -r --cached .cache

# 3. Commit the cleanup
git add .gitignore
git commit -m "chore: ignore Trivy cache directory"
git push
```

**Prevention**: Use the provided `.gitignore` file from this template, which already includes `.cache/`.

---

### Issue 4: Pre-commit Hooks Require Multiple Runs

**Problem**: Running `git commit` fails the first time because hooks modify files (README, formatting), requiring multiple commit attempts.

**Root Cause**: Hook execution order - documentation updates happen after file formatting, creating a cycle.

**Solution**: The `.pre-commit-config.yaml` in this template is already optimized:
1. File fixers run first (end-of-file, trailing-whitespace)
2. Terraform validation runs next (fmt, validate, lint, trivy)
3. Documentation updates run last (terraform_docs)
4. Tests run at the end

**Typical Flow**:
- **First commit**: Pre-commit may update README or fix formatting → fails
- **Second commit**: All fixes applied → passes

This is normal and much better than the 3-4 attempts needed with poor hook ordering.

**Bypass Pre-commit** (for workflow/doc changes only):
```bash
git commit -m "docs: update documentation" --no-verify
```

---

### Issue 5: Module Release Workflow Shows "Skipped"

**Problem**: The `Module Release` workflow runs but shows "This job was skipped".

**Explanation**: This is **expected behavior** in most cases. The workflow only publishes when:

```yaml
on:
  pull_request:
    types: [closed]
    branches:
      - main

jobs:
  publish-module:
    if: github.event.pull_request.merged == true  # ← Only runs if merged
```

**When It Runs**:
- ✅ PR is **merged** to main with a `semver:*` label

**When It's Skipped**:
- ❌ PR is **closed without merging**
- ❌ PR doesn't have a semantic version label
- ❌ Push directly to main (not a PR merge)

**Solution**: This is correct behavior. Only merged PRs should trigger releases.

---

### Issue 6: Semantic Version Label Check Fails

**Problem**: Workflow fails at "Check Required Semantic Version Label" step.

**Root Cause**: PR is missing one of the required labels:
- `semver:patch` - Bug fixes, no breaking changes (1.0.0 → 1.0.1)
- `semver:minor` - New features, backward compatible (1.0.0 → 1.1.0)  
- `semver:major` - Breaking changes (1.0.0 → 2.0.0)

**Solution**: Add exactly ONE of these labels to the PR before merging.

**GitHub CLI**:
```bash
gh pr edit <pr-number> --add-label "semver:patch"
```

**GitHub UI**: Add label from the Labels section in the PR sidebar.

---

## Workflow Execution Flow

### Pull Request Validation Flow

```
Developer Push
    ↓
PR Created/Updated
    ↓
Module Validate Workflow Triggers
    ↓
┌─────────────────────────────────┐
│ 1. Check semver label           │
│ 2. Terraform format check       │
│ 3. Terraform init               │
│ 4. Terraform validate           │
│ 5. TFLint                        │
│ 6. Trivy security scan          │
│ 7. Unit tests                   │
│ 8. Update terraform docs        │
└─────────────────────────────────┘
    ↓
All Checks Pass? → Ready to Merge
```

### Module Release Flow

```
PR Merged to Main
    ↓
Module Release Workflow Triggers
    ↓
┌─────────────────────────────────┐
│ 1. Check if merged (not closed) │
│ 2. Get PR labels                │
│ 3. Determine release type       │
│ 4. Calculate new version        │
│ 5. Publish to TFC registry      │
│ 6. Create release summary       │
└─────────────────────────────────┘
    ↓
Module Available in Registry
```

---

## Required Repository Configuration

### GitHub Repository Settings

**1. Secrets** (Settings → Secrets and variables → Actions):
```
TFE_TOKEN - Terraform Cloud API token with registry permissions
```

**2. Variables** (Settings → Secrets and variables → Actions):
```
TFE_ORG      - Your Terraform Cloud organization name
TFE_MODULE   - Module name (e.g., "terraform-aws-vpc")
TFE_PROVIDER - Provider name (e.g., "aws", "azurerm", "tfe")
```

**3. Branch Protection** (Settings → Branches):
- Require pull request reviews before merging
- Require status checks to pass (select "Validate Module")
- Require branches to be up to date before merging

**4. Labels** (Issues → Labels):
Create these labels if they don't exist:
- `semver:patch` (color: #0e8a16)
- `semver:minor` (color: #fbca04)
- `semver:major` (color: #d73a4a)

---

## Debugging Tips

### View Workflow Runs
```
https://github.com/<owner>/<repo>/actions
```

### Check What Files Will Trigger Workflow
```bash
# See all changed files
git diff origin/main --name-only

# See only files that trigger workflow
git diff origin/main --name-only | grep -E '\.(tf|tfvars|tftest\.hcl)$'
```

### Test Pre-commit Locally
```bash
# Run all hooks
pre-commit run --all-files

# Run specific hook
pre-commit run terraform_fmt --all-files
pre-commit run terraform_docs --all-files
```

### Manually Trigger Workflow
1. Go to Actions tab
2. Select "Module Validate" workflow
3. Click "Run workflow"
4. Select branch
5. Click "Run workflow" button

---

## Quick Reference

| Issue | Solution |
|-------|----------|
| Workflow doesn't run on push | Create a PR instead |
| Workflow doesn't run on PR | Check if `.tf` files changed |
| Workflow file not found | Bootstrap workflows to main first |
| .cache directory tracked | Add to .gitignore, run `git rm -r --cached .cache` |
| Multiple pre-commit runs | Normal - hooks optimized for 1-2 attempts max |
| Release workflow skipped | Only runs on merged PRs with semver labels |
| Label check fails | Add semver:patch/minor/major label to PR |
| Tests fail - missing TFE_TOKEN | Add TFE_TOKEN secret to repository |

---

## Support

If you encounter issues not covered here:
1. Check workflow run logs in the Actions tab
2. Review the IMPROVEMENTS.md for detailed workflow documentation
3. Verify all repository secrets and variables are configured
4. Ensure you're following the PR-based workflow (not pushing directly to main)

---

**Last Updated**: November 2025
