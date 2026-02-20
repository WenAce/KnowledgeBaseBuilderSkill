param(
    [Parameter(Mandatory=$true)]
    [string]$DomainName,
    
    [Parameter(Mandatory=$true)]
    [string]$WorkingDir = "i:\Book\game\game skill"
)

$DomainSkillName = "${DomainName}-knowledge"
$SkillDir = Join-Path -Path $WorkingDir -ChildPath ".agent\skills\$DomainSkillName"
$RefDir = Join-Path -Path $SkillDir -ChildPath "references"
$TempDir = Join-Path -Path $SkillDir -ChildPath ".temp"
$MarkdownDir = Join-Path -Path $WorkingDir -ChildPath "Markdown\$DomainSkillName"

Write-Host "Scaffolding new skill: $DomainSkillName" -ForegroundColor Cyan

# Create directories
if (-not (Test-Path -Path $SkillDir)) {
    New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null
}
if (-not (Test-Path -Path $RefDir)) {
    New-Item -ItemType Directory -Force -Path $RefDir | Out-Null
}
if (-not (Test-Path -Path $TempDir)) {
    New-Item -ItemType Directory -Force -Path $TempDir | Out-Null
}
if (-not (Test-Path -Path $MarkdownDir)) {
    New-Item -ItemType Directory -Force -Path $MarkdownDir | Out-Null
}

# Create base SKILL.md
$SkillMdPath = Join-Path -Path $SkillDir -ChildPath "SKILL.md"
if (-not (Test-Path -Path $SkillMdPath)) {
    $DateStr = (Get-Date).ToString("yyyy-MM-dd")
    $BaseYaml = @"
---
name: $DomainSkillName
description: "This skill should be used when the user asks about $DomainName topics. Provides comprehensive knowledge from authoritative books/documents."
version: 1.0.0
author: AI
created: $DateStr
platforms: [github-copilot-cli, claude-code, codex]
category: knowledge
tags: [$DomainName]
risk: safe
---

# $DomainSkillName

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
"@
    Set-Content -Path $SkillMdPath -Value $BaseYaml -Encoding UTF8
}

# Create README.md
$ReadmePath = Join-Path -Path $SkillDir -ChildPath "README.md"
if (-not (Test-Path -Path $ReadmePath)) {
    $ReadmeContent = @"
# $DomainSkillName

A comprehensive knowledge skill for $DomainName work.

## Source Books
[AI_FILL_BOOKS_TABLE]

## How to Use
Invoke this skill when working on any ${DomainName}-related task.
"@
    Set-Content -Path $ReadmePath -Value $ReadmeContent -Encoding UTF8
}

Write-Host "Scaffold complete! Target directory: $SkillDir" -ForegroundColor Green
Write-Host "Temp directory created for map-reduce chunks: $TempDir" -ForegroundColor Green
Write-Host "Next step for AI: Read books and generate draft insights in $TempDir" -ForegroundColor Yellow
