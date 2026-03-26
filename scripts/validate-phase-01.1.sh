#!/bin/bash
# Phase 01.1 Automated Validation Script
# Verifies presence and basic integrity of all CI/CD and security artifacts.

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "🧪 Starting Phase 01.1 Validation..."

check_file() {
  if [ -f "$1" ]; then
    echo -e "  [${GREEN}OK${NC}] File exists: $1"
  else
    echo -e "  [${RED}FAIL${NC}] File missing: $1"
    exit 1
  fi
}

# 1. Check Workflow Files
echo "Checking GitHub Action workflows..."
check_file ".github/workflows/ci.yml"
check_file ".github/workflows/security.yml"
check_file ".github/workflows/scorecard.yml"

# 2. Check Configuration Files
echo "Checking security and dependency configurations..."
check_file ".github/dependabot.yml"
check_file ".gitleaks.toml"
check_file ".env.example"
check_file "SECURITY.md"

# 3. Check Scripts
echo "Checking architecture and hook scripts..."
check_file "scripts/check-architecture.sh"
check_file ".githooks/pre-commit"

if [ ! -x "scripts/check-architecture.sh" ]; then
  echo -e "  [${RED}FAIL${NC}] scripts/check-architecture.sh is not executable"
  exit 1
fi

if [ ! -x ".githooks/pre-commit" ]; then
  echo -e "  [${RED}FAIL${NC}] .githooks/pre-commit is not executable"
  exit 1
fi

# 4. Run Analysis & Format
echo "Running Flutter analysis..."
flutter analyze --no-fatal-infos

echo "Checking formatting..."
dart format --set-exit-if-changed .

# 5. Run Architecture Check
echo "Running architecture boundary check..."
bash scripts/check-architecture.sh

# 6. Verify Gitleaks Config (if gitleaks installed)
if command -v gitleaks &> /dev/null; then
  echo "Running Gitleaks check..."
  gitleaks detect --source . --no-banner
else
  echo "Gitleaks not found, skipping secret detection scan."
fi

echo -e "\n${GREEN}✅ Phase 01.1 Validation Successful!${NC}"
