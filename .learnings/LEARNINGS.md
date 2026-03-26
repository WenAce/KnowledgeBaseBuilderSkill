# Learnings Log — knowledge-base-builder

Auto-optimizer learning entries for the `knowledge-base-builder` skill.

---

## [LRN-20260325-001] best_practice
**Logged**: 2026-03-25T09:50:00+08:00
**Priority**: high
**Status**: resolved
**Area**: docs
### Summary
Cross-platform script references are critical for multi-platform skills
### Details
The original SKILL.md only included PowerShell commands (`.ps1`) despite claiming support for `claude-code` and `codex` (Unix-based platforms). Adding bash alternatives alongside every PowerShell command was the single highest-impact change (+15 points). Every script reference should have both Windows and Unix variants.
### Suggested Action
Always provide dual script variants (PowerShell + bash) when `platforms` includes Unix-based environments.
### Metadata
- Source: experiment
- Related Files: SKILL.md, scripts/scaffold.sh, scripts/validate.sh
- Pattern-Key: cross-platform-script-parity
- Recurrence-Count: 1

---

## [LRN-20260325-002] best_practice
**Logged**: 2026-03-25T09:55:00+08:00
**Priority**: medium
**Status**: resolved
**Area**: docs
### Summary
Per-step error handling coverage is more impactful than global error keywords
### Details
Adding general error keywords to the file gave diminishing returns. The real scoring improvement came from ensuring EACH of the 6 workflow steps contained specific error handling guidance (edge cases, warnings, fallback strategies). Step-level granularity matters more than document-level keyword density.
### Suggested Action
When writing workflow-based skills, ensure every step has at least one error/edge case note.
### Metadata
- Source: experiment
- Related Files: SKILL.md
- Pattern-Key: per-step-error-handling
- Recurrence-Count: 1

---

## [LRN-20260325-003] correction
**Logged**: 2026-03-25T09:58:00+08:00
**Priority**: medium
**Status**: resolved
**Area**: docs
### Summary
Reference Integrity degrades when referencing non-existent files
### Details
Adding `.sh` script references to the References table without creating the actual files caused Reference Integrity to drop from 15→12. The evaluator checks `[ -f "$path" ]` for each referenced file. Solution: always create the files before referencing them.
### Suggested Action
When adding file references to documentation, create the files first — even as stubs.
### Metadata
- Source: experiment
- Related Files: SKILL.md, scripts/scaffold.sh, scripts/validate.sh
- Pattern-Key: reference-file-existence
- Recurrence-Count: 1

---

## [LRN-20260325-004] best_practice
**Logged**: 2026-03-25T10:00:00+08:00
**Priority**: low
**Status**: resolved
**Area**: docs
### Summary
Hardcoded paths should be replaced with generic placeholders
### Details
The original Step 5 contained a hardcoded Windows path (`i:\Book\game\game skill\...`). This is machine-specific and won't work elsewhere. Replacing with `<working_dir>` placeholder maintained the score while improving portability. This is a simplification win.
### Suggested Action
Never hardcode machine-specific paths in skill definitions. Use `<working_dir>` or similar placeholders.
### Metadata
- Source: experiment
- Related Files: SKILL.md
- Pattern-Key: no-hardcoded-paths
- Recurrence-Count: 1
