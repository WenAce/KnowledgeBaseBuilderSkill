#!/bin/bash
# scaffold.sh — Cross-platform bash equivalent of scaffold.ps1
# Creates the skill directory structure for a new domain-knowledge skill.
# Usage: bash scripts/scaffold.sh --domain "<domain>"

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
    echo "Usage: bash scripts/scaffold.sh --domain \"<domain>\""
    exit 1
fi

SKILL_NAME="${DOMAIN}-knowledge"
SKILL_DIR=".agent/skills/${SKILL_NAME}"
REF_DIR="${SKILL_DIR}/references"
TEMP_DIR="${SKILL_DIR}/.temp"
MARKDOWN_DIR="Markdown/${SKILL_NAME}"

echo "Scaffolding new skill: ${SKILL_NAME}"

mkdir -p "$SKILL_DIR" "$REF_DIR" "$TEMP_DIR" "$MARKDOWN_DIR"

SKILL_MD="${SKILL_DIR}/SKILL.md"
if [ ! -f "$SKILL_MD" ]; then
    DATE_STR=$(date +%Y-%m-%d)
    cat > "$SKILL_MD" << EOF
---
name: ${SKILL_NAME}
description: "This skill should be used when the user asks about ${DOMAIN} topics. Provides comprehensive knowledge from authoritative books/documents."
version: 1.0.0
author: AI
created: ${DATE_STR}
platforms: [github-copilot-cli, claude-code, codex, antigravity]
category: knowledge
tags: [${DOMAIN}]
risk: safe
---

# ${SKILL_NAME}

## Purpose
[AI_FILL_PURPOSE]

## When to Use This Skill
[AI_FILL_SCENARIOS]

## Knowledge Domains
[AI_FILL_DOMAINS]

## Quick Reference Decision Tree
[AI_FILL_DECISION_TREE]

## Source Books
[AI_FILL_BOOKS]
EOF
fi

README="${SKILL_DIR}/README.md"
if [ ! -f "$README" ]; then
    cat > "$README" << EOF
# ${SKILL_NAME}

A comprehensive knowledge skill for ${DOMAIN} work.

## Source Books
[AI_FILL_BOOKS_TABLE]

## How to Use
Invoke this skill when working on any ${DOMAIN}-related task.
EOF
fi

echo "Scaffold complete! Target directory: ${SKILL_DIR}"
echo "Temp directory created for map-reduce chunks: ${TEMP_DIR}"
echo "Next step for AI: Read books and generate draft insights in ${TEMP_DIR}"
