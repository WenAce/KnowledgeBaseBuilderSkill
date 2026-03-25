#!/bin/bash
# eval-skill.sh — Multi-dimensional evaluator for SKILL.md quality (v2 - stricter)
# Outputs: SCORE: <number>/100
# Used by auto-optimizer as the objective function.
# Total raw points: 200, scaled to 100.

SKILL_FILE="SKILL.md"

# ============================================================
# Dimension 1: Structure Completeness (30 raw points)
# ============================================================
dim1=0

# YAML frontmatter
if head -1 "$SKILL_FILE" | grep -q "^---"; then dim1=$((dim1 + 2)); fi

# Required sections
for section in "## Purpose" "## Trigger" "### Step 1" "### Step 2" "### Step 3" "### Step 4" "### Step 5" "### Step 6" "## References" "## Quick Example"; do
    if grep -q "$section" "$SKILL_FILE"; then dim1=$((dim1 + 2)); fi
done

# 6-step completeness
step_count=$(grep -c "^### Step [1-6]" "$SKILL_FILE")
if [ "$step_count" -ge 6 ]; then dim1=$((dim1 + 4)); fi

# Each step has a descriptive subtitle (e.g., "Step 1 — Environment Scan")
titled_steps=$(grep -cE "^### Step [1-6] —" "$SKILL_FILE")
if [ "$titled_steps" -ge 6 ]; then dim1=$((dim1 + 4)); fi

if [ "$dim1" -gt 30 ]; then dim1=30; fi

# ============================================================
# Dimension 2: Cross-Platform Compatibility (25 raw points)
# ============================================================
dim2=0

ps_refs=$(grep -ci "\.ps1\|powershell" "$SKILL_FILE")
bash_refs=$(grep -ci "\.sh\|bash\|/bin/sh\|shell script" "$SKILL_FILE")
cross_platform=$(grep -ci "cross.platform\|linux\|macos\|unix\|platform.independent" "$SKILL_FILE")

if [ "$bash_refs" -gt 0 ]; then dim2=$((dim2 + 5)); fi
if [ "$cross_platform" -gt 0 ]; then dim2=$((dim2 + 5)); fi
if [ "$ps_refs" -gt 0 ] && [ "$bash_refs" -gt 0 ]; then dim2=$((dim2 + 5)); fi
if grep -qi "antigravity" "$SKILL_FILE"; then dim2=$((dim2 + 3)); fi

# NEW: Check that cross-platform note appears near EACH script command
ps1_blocks=$(grep -c "\.ps1" "$SKILL_FILE")
sh_blocks=$(grep -c "\.sh" "$SKILL_FILE")
if [ "$sh_blocks" -ge "$ps1_blocks" ] && [ "$ps1_blocks" -gt 0 ]; then
    dim2=$((dim2 + 5))
fi

# NEW: Does it mention platform detection / auto-detection?
if grep -qi "detect.*platform\|platform.*detect\|auto.detect\|os.*detect" "$SKILL_FILE"; then
    dim2=$((dim2 + 2))
fi

if [ "$dim2" -gt 25 ]; then dim2=25; fi

# ============================================================
# Dimension 3: Error Handling & Resilience (30 raw points)
# ============================================================
dim3=0

# Basic error keywords
error_keywords=$(grep -ci "error\|fail\|fallback\|edge.case\|cannot\|unable\|retry\|recover\|handle\|exception\|warning" "$SKILL_FILE")
if [ "$error_keywords" -ge 1 ]; then dim3=$((dim3 + 2)); fi
if [ "$error_keywords" -ge 3 ]; then dim3=$((dim3 + 2)); fi
if [ "$error_keywords" -ge 5 ]; then dim3=$((dim3 + 2)); fi
if [ "$error_keywords" -ge 8 ]; then dim3=$((dim3 + 2)); fi
if [ "$error_keywords" -ge 12 ]; then dim3=$((dim3 + 2)); fi

# Explicit conditional error logic
explicit=$(grep -ci "if.*fail\|if.*not found\|if.*error\|if.*cannot\|MUST fix\|run.*again.*until" "$SKILL_FILE")
if [ "$explicit" -ge 1 ]; then dim3=$((dim3 + 3)); fi
if [ "$explicit" -ge 3 ]; then dim3=$((dim3 + 3)); fi

# NEW: per-step error handling (each step should mention what to do on failure)
steps_with_error=0
for step_num in 1 2 3 4 5 6; do
    # Check if there's error-related text between this step and the next
    step_content=$(sed -n "/^### Step $step_num/,/^### Step $((step_num+1))\|^## /p" "$SKILL_FILE")
    if echo "$step_content" | grep -qi "error\|fail\|fallback\|edge.case\|cannot\|warning\|halt\|retry"; then
        steps_with_error=$((steps_with_error + 1))
    fi
done
dim3=$((dim3 + steps_with_error * 2))

# NEW: Does it mention graceful degradation / partial success?
if grep -qi "partial\|graceful\|degrad\|skip.*and.*continue\|remaining" "$SKILL_FILE"; then
    dim3=$((dim3 + 2))
fi

if [ "$dim3" -gt 30 ]; then dim3=30; fi

# ============================================================
# Dimension 4: Instruction Specificity & Actionability (25 raw points)
# ============================================================
dim4=0

# Code blocks
code_blocks=$(grep -c '```' "$SKILL_FILE")
code_blocks=$((code_blocks / 2))
if [ "$code_blocks" -ge 2 ]; then dim4=$((dim4 + 3)); fi
if [ "$code_blocks" -ge 4 ]; then dim4=$((dim4 + 3)); fi
if [ "$code_blocks" -ge 6 ]; then dim4=$((dim4 + 2)); fi

# Numbered sub-steps
numbered_steps=$(grep -cE "^[0-9]+\." "$SKILL_FILE")
if [ "$numbered_steps" -ge 5 ]; then dim4=$((dim4 + 2)); fi
if [ "$numbered_steps" -ge 10 ]; then dim4=$((dim4 + 2)); fi
if [ "$numbered_steps" -ge 15 ]; then dim4=$((dim4 + 2)); fi

# NEW: Specific path/filename patterns (shows actionability)
path_patterns=$(grep -cE "\.[a-z]+/" "$SKILL_FILE")
if [ "$path_patterns" -ge 3 ]; then dim4=$((dim4 + 2)); fi
if [ "$path_patterns" -ge 6 ]; then dim4=$((dim4 + 2)); fi

# NEW: Uses bold/emphasis for key instructions
bold_critical=$(grep -ci "\*\*CRITICAL\*\*\|\*\*MUST\*\*\|\*\*WARNING\*\*\|\*\*NOTE\*\*\|\*\*Error handling\*\*\|\*\*Edge case\*\*\|\*\*Validation\*\*" "$SKILL_FILE")
if [ "$bold_critical" -ge 2 ]; then dim4=$((dim4 + 3)); fi
if [ "$bold_critical" -ge 4 ]; then dim4=$((dim4 + 2)); fi

# NEW: Word count — too short means not enough detail
word_count=$(wc -w < "$SKILL_FILE" | tr -d ' ')
if [ "$word_count" -ge 400 ]; then dim4=$((dim4 + 1)); fi
if [ "$word_count" -ge 600 ]; then dim4=$((dim4 + 1)); fi
if [ "$word_count" -ge 800 ]; then dim4=$((dim4 + 1)); fi

if [ "$dim4" -gt 25 ]; then dim4=25; fi

# ============================================================
# Dimension 5: Reference Integrity (15 raw points)
# ============================================================
dim5=0
total_refs=0
valid_refs=0

while IFS= read -r ref_path; do
    clean_path=$(echo "$ref_path" | sed 's/[)(]//g' | sed 's/^[[:space:]]*//')
    if [ -n "$clean_path" ] && [ -f "$clean_path" ]; then
        valid_refs=$((valid_refs + 1))
    fi
    total_refs=$((total_refs + 1))
done < <(grep -oE '\([a-zA-Z0-9_./-]+\.(ps1|md|sh|py)\)' "$SKILL_FILE" | tr -d '()')

if [ "$total_refs" -gt 0 ]; then
    ratio=$((valid_refs * 10 / total_refs))
    dim5=$ratio
else
    dim5=3
fi

# NEW: Does it reference its own sub-files properly?
if grep -q "references/pdf-tools.md" "$SKILL_FILE"; then dim5=$((dim5 + 2)); fi
if grep -q "references/skill-template.md" "$SKILL_FILE"; then dim5=$((dim5 + 1)); fi
if grep -q "references/knowledge-extraction.md" "$SKILL_FILE"; then dim5=$((dim5 + 1)); fi

# NEW: Is the References section formatted as a table?
ref_section=$(sed -n '/^## References/,/^## /p' "$SKILL_FILE")
ref_table_rows=$(echo "$ref_section" | grep -c "^|")
if [ "$ref_table_rows" -ge 4 ]; then dim5=$((dim5 + 1)); fi

if [ "$dim5" -gt 15 ]; then dim5=15; fi

# ============================================================
# Dimension 6: Documentation Quality (25 raw points)
# ============================================================
dim6=0

# YAML frontmatter fields
yaml_fields=$(grep -cE "^(name|description|version|author|created|platforms|category|tags|risk):" "$SKILL_FILE")
if [ "$yaml_fields" -ge 5 ]; then dim6=$((dim6 + 3)); fi
if [ "$yaml_fields" -ge 8 ]; then dim6=$((dim6 + 3)); fi

# Tables
table_count=$(grep -c "^|" "$SKILL_FILE")
if [ "$table_count" -ge 2 ]; then dim6=$((dim6 + 2)); fi
if [ "$table_count" -ge 6 ]; then dim6=$((dim6 + 2)); fi

# Horizontal rules
hr_count=$(grep -c "^---$" "$SKILL_FILE")
if [ "$hr_count" -ge 3 ]; then dim6=$((dim6 + 2)); fi
if [ "$hr_count" -ge 5 ]; then dim6=$((dim6 + 2)); fi

# Bold emphasis
bold_count=$(grep -c "\*\*" "$SKILL_FILE")
if [ "$bold_count" -ge 3 ]; then dim6=$((dim6 + 1)); fi
if [ "$bold_count" -ge 8 ]; then dim6=$((dim6 + 2)); fi

# NEW: Total line count (balanced — not too short, not bloated)
line_count=$(wc -l < "$SKILL_FILE" | tr -d ' ')
if [ "$line_count" -ge 80 ]; then dim6=$((dim6 + 2)); fi
if [ "$line_count" -ge 120 ]; then dim6=$((dim6 + 2)); fi
if [ "$line_count" -ge 160 ]; then dim6=$((dim6 + 2)); fi
# Penalty for being too long (over 300 lines = bloat)
if [ "$line_count" -gt 300 ]; then dim6=$((dim6 - 4)); fi

# NEW: Consistent heading hierarchy (no jumps from ## to ####)
heading_jump=$(grep -cE "^####" "$SKILL_FILE")
if [ "$heading_jump" -eq 0 ]; then dim6=$((dim6 + 2)); fi

if [ "$dim6" -gt 25 ]; then dim6=25; fi

# ============================================================
# Dimension 7: Discoverability & Metadata (20 raw points)
# ============================================================
dim7=0

# Description length
desc_line=$(grep "^description:" "$SKILL_FILE")
desc_len=${#desc_line}
if [ "$desc_len" -ge 50 ]; then dim7=$((dim7 + 2)); fi
if [ "$desc_len" -ge 100 ]; then dim7=$((dim7 + 2)); fi
if [ "$desc_len" -ge 150 ]; then dim7=$((dim7 + 2)); fi
if [ "$desc_len" -ge 200 ]; then dim7=$((dim7 + 2)); fi

# Tags count
tags_line=$(grep "^tags:" "$SKILL_FILE")
tag_count=$(echo "$tags_line" | tr ',' '\n' | wc -l)
if [ "$tag_count" -ge 3 ]; then dim7=$((dim7 + 2)); fi
if [ "$tag_count" -ge 5 ]; then dim7=$((dim7 + 2)); fi
if [ "$tag_count" -ge 7 ]; then dim7=$((dim7 + 2)); fi

# NEW: Does description mention trigger keywords?
if echo "$desc_line" | grep -qi "generate skill\|create knowledge\|build knowledge"; then
    dim7=$((dim7 + 3))
fi

# NEW: Version, author, created all present?
meta_fields=0
if grep -q "^version:" "$SKILL_FILE"; then meta_fields=$((meta_fields + 1)); fi
if grep -q "^author:" "$SKILL_FILE"; then meta_fields=$((meta_fields + 1)); fi
if grep -q "^created:" "$SKILL_FILE"; then meta_fields=$((meta_fields + 1)); fi
if [ "$meta_fields" -eq 3 ]; then dim7=$((dim7 + 3)); fi

if [ "$dim7" -gt 20 ]; then dim7=20; fi

# ============================================================
# Dimension 8: Workflow Robustness (30 raw points) — NEW
# Does the workflow handle real-world scenarios?
# ============================================================
dim8=0

# Does it mention context limits / token limits?
if grep -qi "context.limit\|token.limit\|context.window\|one.by.one\|one at a time" "$SKILL_FILE"; then
    dim8=$((dim8 + 4))
fi

# Does it have a map-reduce pattern?
if grep -qi "map.*reduce\|map)\|reduce)" "$SKILL_FILE"; then
    dim8=$((dim8 + 4))
fi

# Does Step 2 mention processing books individually?
step2=$(sed -n '/^### Step 2/,/^### Step 3/p' "$SKILL_FILE")
if echo "$step2" | grep -qi "each book\|one by one\|individually"; then
    dim8=$((dim8 + 4))
fi

# Does it mention intermediate files / temp storage?
if grep -qi "\.temp\|intermediate\|draft-" "$SKILL_FILE"; then
    dim8=$((dim8 + 4))
fi

# Does it have clear input/output definition?
if grep -qi "\*\*Input\*\*:" "$SKILL_FILE"; then dim8=$((dim8 + 3)); fi
if grep -qi "\*\*Output\*\*:" "$SKILL_FILE"; then dim8=$((dim8 + 3)); fi

# Does Step 6 mention re-running on failure?
step6=$(sed -n '/^### Step 6/,/^## /p' "$SKILL_FILE")
if echo "$step6" | grep -qi "again.*until\|retry\|re-run\|MUST.*fix"; then
    dim8=$((dim8 + 4))
fi

# Does it mention the relationship with pdf-tools / tool detection?
if grep -qi "pdf.tool\|tool.*detect\|detect.*tool" "$SKILL_FILE"; then
    dim8=$((dim8 + 4))
fi

if [ "$dim8" -gt 30 ]; then dim8=30; fi

# ============================================================
# Final Score (200 raw → scaled to 100)
# ============================================================
RAW=$((dim1 + dim2 + dim3 + dim4 + dim5 + dim6 + dim7 + dim8))
SCORE=$((RAW * 100 / 200))

echo "=== SKILL.md Evaluation Report (v2) ==="
echo "Dimension 1 - Structure Completeness:     $dim1/30"
echo "Dimension 2 - Cross-Platform Compat:      $dim2/25"
echo "Dimension 3 - Error Handling & Resilience: $dim3/30"
echo "Dimension 4 - Instruction Specificity:     $dim4/25"
echo "Dimension 5 - Reference Integrity:         $dim5/15"
echo "Dimension 6 - Documentation Quality:       $dim6/25"
echo "Dimension 7 - Discoverability & Metadata:  $dim7/20"
echo "Dimension 8 - Workflow Robustness:         $dim8/30"
echo "========================================="
echo "Raw: $RAW/200"
echo "SCORE: $SCORE/100"
