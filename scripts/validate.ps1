param(
    [Parameter(Mandatory=$true)]
    [string]$DomainName,
    
    [Parameter(Mandatory=$true)]
    [string]$WorkingDir = "i:\Book\game\game skill"
)

$DomainSkillName = "${DomainName}-knowledge"
$SkillDir = Join-Path -Path $WorkingDir -ChildPath ".agent\skills\$DomainSkillName"
$RefDir = Join-Path -Path $SkillDir -ChildPath "references"
$MarkdownDir = Join-Path -Path $WorkingDir -ChildPath "Markdown\$DomainSkillName"
$SkillMdPath = Join-Path -Path $SkillDir -ChildPath "SKILL.md"

Write-Host "Verifying skill: $DomainSkillName" -ForegroundColor Cyan
$HasErrors = $false

function Assert-Check {
    param([bool]$Condition, [string]$Message)
    if ($Condition) {
        Write-Host "[✓] $Message" -ForegroundColor Green
    } else {
        Write-Host "[X] $Message" -ForegroundColor Red
        $script:HasErrors = $true
    }
}

# 1. Check directories
Assert-Check (Test-Path $SkillDir) "Skill directory exists ($SkillDir)"
Assert-Check (Test-Path $RefDir) "References directory exists ($RefDir)"

# 2. Check SKILL.md
if (Test-Path $SkillMdPath) {
    Assert-Check $true "SKILL.md exists"
    $Content = Get-Content $SkillMdPath -Raw
    
    # Check if placeholders are replaced
    Assert-Check (-not $Content.Contains("[AI_FILL_PURPOSE]")) "SKILL.md: Purpose is written"
    Assert-Check (-not $Content.Contains("[AI_FILL_SCENARIOS]")) "SKILL.md: Scenarios are written"
    Assert-Check (-not $Content.Contains("[AI_FILL_DOMAINS]")) "SKILL.md: Domains are written"
    Assert-Check (-not $Content.Contains("[AI_FILL_DECISION_TREE]")) "SKILL.md: Decision Tree is written"
} else {
    Assert-Check $false "SKILL.md exists"
}

# 3. Check reference files
if (Test-Path $RefDir) {
    $MdFiles = Get-ChildItem -Path $RefDir -Filter "*.md"
    Assert-Check ($MdFiles.Count -gt 0) "At least one Markdown file exists in references/"
}

# 4. Check Markdown sync
if (Test-Path $MarkdownDir) {
    $MarkdownFiles = Get-ChildItem -Path $MarkdownDir -Recurse -Filter "*.md"
    Assert-Check ($MarkdownFiles.Count -gt 0) "Markdown folder has synced content"
} else {
    Assert-Check $false "Markdown sync folder exists"
}

Write-Host "--------------------------------"
if ($HasErrors) {
    Write-Host "Validation FAILED. Please fix the missing or incomplete components." -ForegroundColor Red
    exit 1
} else {
    Write-Host "Validation PASSED! The new skill is fully structural and ready." -ForegroundColor Green
    exit 0
}
