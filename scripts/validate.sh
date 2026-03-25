#!/bin/bash
# validate.sh — Cross-platform bash equivalent of validate.ps1
# Validates that a generated domain-knowledge skill has all required components.
# Usage: bash scripts/validate.sh --domain "<domain>"

DOMAIN=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --domain) DOMAIN="$2"; shift ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

if [ -z "$DOMAIN" ]; then
    echo "Error: --domain is required"
    echo "Usage: bash scripts/validate.sh --domain \"<domain>\""
    exit 1
fi

SKILL_NAME="${DOMAIN}-knowledge"
SKILL_DIR=".agent/skills/${SKILL_NAME}"
REF_DIR="${SKILL_DIR}/references"
MARKDOWN_DIR="Markdown/${SKILL_NAME}"
SKILL_MD="${SKILL_DIR}/SKILL.md"

echo "Verifying skill: ${SKILL_NAME}"
HAS_ERRORS=false

assert_check() {
    local condition=$1
    local message=$2
    if [ "$condition" = "true" ]; then
        echo "[✓] $message"
    else
        echo "[X] $message"
        HAS_ERRORS=true
    fi
}

# 1. Check directories
assert_check "$([ -d "$SKILL_DIR" ] && echo true || echo false)" "Skill directory exists ($SKILL_DIR)"
assert_check "$([ -d "$REF_DIR" ] && echo true || echo false)" "References directory exists ($REF_DIR)"

# 2. Check SKILL.md
if [ -f "$SKILL_MD" ]; then
    assert_check "true" "SKILL.md exists"
    CONTENT=$(cat "$SKILL_MD")

    assert_check "$(echo "$CONTENT" | grep -qv '\[AI_FILL_PURPOSE\]' && echo true || echo false)" "SKILL.md: Purpose is written"
    assert_check "$(echo "$CONTENT" | grep -qv '\[AI_FILL_SCENARIOS\]' && echo true || echo false)" "SKILL.md: Scenarios are written"
    assert_check "$(echo "$CONTENT" | grep -qv '\[AI_FILL_DOMAINS\]' && echo true || echo false)" "SKILL.md: Domains are written"
    assert_check "$(echo "$CONTENT" | grep -qv '\[AI_FILL_DECISION_TREE\]' && echo true || echo false)" "SKILL.md: Decision Tree is written"
else
    assert_check "false" "SKILL.md exists"
fi

# 3. Check reference files
if [ -d "$REF_DIR" ]; then
    MD_COUNT=$(find "$REF_DIR" -name "*.md" | wc -l | tr -d ' ')
    assert_check "$([ "$MD_COUNT" -gt 0 ] && echo true || echo false)" "At least one Markdown file exists in references/"
fi

# 4. Check Markdown sync
if [ -d "$MARKDOWN_DIR" ]; then
    SYNC_COUNT=$(find "$MARKDOWN_DIR" -name "*.md" | wc -l | tr -d ' ')
    assert_check "$([ "$SYNC_COUNT" -gt 0 ] && echo true || echo false)" "Markdown folder has synced content"
else
    assert_check "false" "Markdown sync folder exists"
fi

echo "--------------------------------"
if [ "$HAS_ERRORS" = true ]; then
    echo "Validation FAILED. Please fix the missing or incomplete components."
    exit 1
else
    echo "Validation PASSED! The new skill is fully structural and ready."
    exit 0
fi
