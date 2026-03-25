---
name: knowledge-base-builder
description: "Use this skill to build a domain-specific knowledge skill from books and documents. Triggers on: 'generate skill', 'create knowledge base', 'build knowledge skill', 'generate skill from books'. Place books/PDFs in the book/ folder, then run the 6-step workflow to generate a complete, domain-specific skill (like game-dev-knowledge) that can be used for all work in that domain."
version: 1.0.0
author: LWF
created: 2026-02-19
platforms: [github-copilot-cli, claude-code, codex]
category: meta
tags: [skill-builder, knowledge-base, pdf, book, domain-skill]
risk: safe
---

# knowledge-base-builder

## Purpose

A **meta-skill** that transforms books and documents into a fully functional domain-specific skill — it serves all work in that domain.

**Input**: Books/PDFs placed in the `book/` folder  
**Trigger**: User types `generate skill`  
**Output**: A complete `.agent/skills/<domain>-knowledge/` skill folder

---

## Trigger Keyword

When the user types **`generate skill`**, immediately begin the 6-step workflow below.

---

## 6-Step Generation Workflow

### Step 1 — Environment Scan

1. List all files in the `book/` folder.
2. Ask the user two questions:
   - **Q1**: What is the domain name for this knowledge base? (e.g., medical, legal, finance)
   - **Q2**: What are the main work scenarios this Skill will cover?
3. Once answered, run the scaffold script to initialize the project tree:
   ```powershell
   .\scripts\scaffold.ps1 -Domain "<domain>"
   ```

### Step 2 — Knowledge Extraction (Map)

**CRITICAL**: Do not try to read all books and write the skill in one go. You will hit context limits. Process them one by one.
1. For **each book**, read its contents using the appropriate PDF/text tool.
2. Create an intermediate insight file for that book in the newly created `.temp/` folder: `.agent/skills/<domain>-knowledge/.temp/draft-<book_name>.md`.
3. Extract and save: Core concepts, Best practices, Decision rules, and Key Insights.
4. Repeat this step until all books are processed.

### Step 3 — Structure Synthesis (Plan)

1. Read all the `draft-*.md` intermediate files from the `.temp/` folder.
2. Identify 2~6 overarching knowledge domains across all the drafts.
3. Design the Quick Reference Decision Tree ("User is working on X -> points to domain Y").
4. Plan the specific `references/*.md` files to be generated.

### Step 4 — Generate Skill Files (Reduce)

1. Fill in all the `[AI_FILL_*]` placeholders in `.agent/skills/<domain>-knowledge/SKILL.md`.
2. Generate the detailed `references/<domain>.md` files based on the synthesized knowledge.
3. Update `.agent/skills/<domain>-knowledge/README.md` to finalize the source books table.

### Step 5 — Sync Markdown Copy

1. Sync the final files by copying them to the Markdown mirror folder:
   ```powershell
   Copy-Item -Path "i:\Book\game\game skill\.agent\skills\<domain>-knowledge\*" -Destination "i:\Book\game\game skill\Markdown\<domain>-knowledge\" -Recurse -Force
   ```

### Step 6 — Validation (Test)

1. Run the validation script to ensure no steps were skipped:
   ```powershell
   .\scripts\validate.ps1 -Domain "<domain>"
   ```
2. If the script reports `FAILED`, you **MUST** fix the missing and incomplete components and run it again until it passes.

---

## References

| File | Contents |
|------|----------|
| [scripts/scaffold.ps1](scripts/scaffold.ps1) | Automation script for folder scaffolding |
| [scripts/validate.ps1](scripts/validate.ps1) | Automated integrity checklist script |
| [references/pdf-tools.md](references/pdf-tools.md) | PDF tool detection and fallback strategy |
| [references/skill-template.md](references/skill-template.md) | Standard template for generated Skills |
| [references/knowledge-extraction.md](references/knowledge-extraction.md) | Knowledge extraction methodology |
| [book/README.md](book/README.md) | How to place books and documents |

---

## Quick Example

```
User: generate skill

AI: [Step 1] Scanning book/ folder...
    Found 3 files:
    - game-ai-guide.pdf           (readable: pdf-official)
    - engine-architecture.md      (direct read)
    - physics-book.txt            (direct read)

    Please answer:
    1. Domain name? → User: "Game Development"
    2. Main work scenarios? → User: "AI behaviors, physics simulation, engine optimization"

AI: [Step 2] Extracting knowledge...
    [Step 3] Planning structure: game-development-knowledge
             Domains: AI Systems / Physics Engine / Engine Architecture / Performance
    [Step 4] Generating files:
             ✓ .agent/skills/game-development-knowledge/SKILL.md
             ✓ .agent/skills/game-development-knowledge/references/ai.md
             ...
    [Step 5] Syncing to Markdown/game-development-knowledge/
    [Step 6] Verifying: Answering "How to implement pathfinding?" with new Skill → ✓
```
