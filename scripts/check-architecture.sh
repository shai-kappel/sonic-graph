#!/bin/bash
# Architecture Boundary Check for SonicGraph
# Enforces clean architecture layer rules:
#   - domain/ must NOT import from presentation/ or data/
#   - data/ must NOT import from presentation/
#   - core/ must NOT import from features/
#
# Usage: ./scripts/check-architecture.sh
# Exit code: 0 = pass, 1 = violations found

set -euo pipefail

VIOLATIONS=0
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "🏗️  Checking architecture boundaries..."

# Rule 1: domain/ must not import from presentation/
echo -n "  Checking domain → presentation boundary... "
DOMAIN_PRES=$(grep -rn "import.*presentation" lib/features/*/domain/ 2>/dev/null || true)
if [ -n "$DOMAIN_PRES" ]; then
  echo -e "${RED}FAIL${NC}"
  echo "$DOMAIN_PRES"
  VIOLATIONS=$((VIOLATIONS + 1))
else
  echo -e "${GREEN}OK${NC}"
fi

# Rule 2: domain/ must not import from data/
echo -n "  Checking domain → data boundary... "
DOMAIN_DATA=$(grep -rn "import.*\/data\/" lib/features/*/domain/ 2>/dev/null || true)
if [ -n "$DOMAIN_DATA" ]; then
  echo -e "${RED}FAIL${NC}"
  echo "$DOMAIN_DATA"
  VIOLATIONS=$((VIOLATIONS + 1))
else
  echo -e "${GREEN}OK${NC}"
fi

# Rule 3: data/ must not import from presentation/
echo -n "  Checking data → presentation boundary... "
DATA_PRES=$(grep -rn "import.*presentation" lib/features/*/data/ 2>/dev/null || true)
if [ -n "$DATA_PRES" ]; then
  echo -e "${RED}FAIL${NC}"
  echo "$DATA_PRES"
  VIOLATIONS=$((VIOLATIONS + 1))
else
  echo -e "${GREEN}OK${NC}"
fi

# Rule 4: core/ must not import from features/
echo -n "  Checking core → features boundary... "
CORE_FEAT=$(grep -rn "import.*features" lib/core/ 2>/dev/null || true)
if [ -n "$CORE_FEAT" ]; then
  echo -e "${RED}FAIL${NC}"
  echo "$CORE_FEAT"
  VIOLATIONS=$((VIOLATIONS + 1))
else
  echo -e "${GREEN}OK${NC}"
fi

# Rule 5: No Flutter imports in domain layer
echo -n "  Checking domain has no Flutter imports... "
DOMAIN_FLUTTER=$(grep -rn "import.*package:flutter" lib/features/*/domain/ 2>/dev/null || true)
if [ -n "$DOMAIN_FLUTTER" ]; then
  echo -e "${RED}FAIL${NC}"
  echo "$DOMAIN_FLUTTER"
  VIOLATIONS=$((VIOLATIONS + 1))
else
  echo -e "${GREEN}OK${NC}"
fi

echo ""
if [ $VIOLATIONS -gt 0 ]; then
  echo -e "${RED}✗ $VIOLATIONS architecture violation(s) found${NC}"
  exit 1
else
  echo -e "${GREEN}✓ All architecture boundaries respected${NC}"
  exit 0
fi
