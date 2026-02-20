# knowledge-base-builder

A **meta-skill** that transforms your books and documents into a fully functional domain-specific skill — just like `game-dev-knowledge` serves all game development work, you can generate the equivalent for **any domain**.

---

## What It Does

```
Your books/documents  →  knowledge-base-builder  →  Domain Expert Skill
  (PDF, MD, TXT)            (generate skill)          (ready to use)
```

The generated skill works like `game-dev-knowledge`: it understands domain context, provides best practices, helps make decisions, and serves as an expert reference for any task in that domain.

---

## Quick Start

1. **Place your books** in the `book/` folder (PDF, MD, TXT, DOCX)
2. **Type the trigger**: `generate skill`
3. **Answer 2 questions** when prompted
4. **Done** — your domain skill is created in `.agent/skills/<domain>-knowledge/`

---

## Trigger Keyword

| Keyword | Action |
|---------|--------|
| `generate skill` | Starts the full 6-step generation workflow |

---

## The 6-Step Workflow

| Step | Name | What Happens |
|------|------|--------------|
| 1 | **Environment Scan** | Scans `book/`, asks 2 questions, runs `scaffold.ps1` to build the folder tree |
| 2 | **Knowledge Extraction (Map)** | Reads books **one by one**, saving intermediate `draft-*.md` files to `.temp/` |
| 3 | **Plan Structure** | Synthesizes drafts into knowledge domains and a decision tree |
| 4 | **Generate Skill Files (Reduce)** | Fills in templates to create the final `SKILL.md` and `references/*.md` files |
| 5 | **Sync Markdown Copy** | Copies all files to `Markdown/<domain>-knowledge/` |
| 6 | **Verify** | Runs `validate.ps1` to ensure all fields are filled and files exist. Fixes if failed. |

---

## Supported Input Formats

| Format | Tool Required | Notes |
|--------|--------------|-------|
| `.pdf` | `pdf-official` or `firecrawl` skill | Most feature-rich |
| `.md`  | None | Recommended for notes and summaries |
| `.txt` | None | Always readable |
| `.docx` | `docx` skill | Word documents |

If no PDF tool is available, the system prompts you to paste text content directly.

---

## Output Structure

After running `generate skill`, you get:

```
.agent/skills/<domain>-knowledge/
├── SKILL.md            ← Full domain expert skill with knowledge domains + decision tree
├── README.md           ← Book list and usage guide
└── references/
    ├── <domain1>.md    ← Detailed content for knowledge domain 1
    ├── <domain2>.md    ← Detailed content for knowledge domain 2
    └── ...

Markdown/<domain>-knowledge/   ← Synchronized copy
```

The generated skill is modeled on `game-dev-knowledge` and includes:

- **Knowledge Domains** — organized topic areas with core concepts and best practices
- **Key Insights** — author-attributed insights from each book
- **Decision Tree** — "What are you working on? → Go to Domain X"
- **Source Books Table** — complete reference for deeper reading

---

## Example Session

```
User: generate skill

AI: Scanning book/ folder...
    Found: physics-textbook.pdf, chemistry-notes.md, biology-guide.txt

    No pdf-official skill detected.
    Can read: chemistry-notes.md, biology-guide.txt
    Cannot read: physics-textbook.pdf → will ask for summary

    Questions:
    1. Domain name? → "Life Sciences"
    2. Work scenarios? → "Research review, experiment design, lab troubleshooting"

AI: Extracting knowledge from 2 readable files...
    [Identified 3 domains: Biology, Chemistry, Lab Methods]
    [User provides physics summary → merged into extraction]

    Planning skill structure: life-sciences-knowledge
    Generating files...
    ✓ .agent/skills/life-sciences-knowledge/SKILL.md
    ✓ .agent/skills/life-sciences-knowledge/references/biology.md
    ✓ .agent/skills/life-sciences-knowledge/references/chemistry.md
    ✓ .agent/skills/life-sciences-knowledge/references/lab-methods.md
    ✓ .agent/skills/life-sciences-knowledge/README.md
    Syncing to Markdown/life-sciences-knowledge/ ✓

    Verifying: "How do I design a control experiment?" → ✓ answered from new skill
    Generation complete!
```

---

## File Reference

| File | Purpose |
|------|---------|
| [`SKILL.md`](SKILL.md) | Main skill entry — full 6-step workflow |
| [`scripts/scaffold.ps1`](scripts/scaffold.ps1) | Setup script that generates the target folder structure |
| [`scripts/validate.ps1`](scripts/validate.ps1) | CI/CD style integrity checker to enforce AI completion |
| [`book/README.md`](book/README.md) | How to place books in the `book/` folder |
| [`references/pdf-tools.md`](references/pdf-tools.md) | PDF tool detection and fallback strategy |
| [`references/skill-template.md`](references/skill-template.md) | Standard template for the generated skill |
| [`references/knowledge-extraction.md`](references/knowledge-extraction.md) | Knowledge extraction methodology |

---

## Design Principles

- **Map-Reduce state management** — processes books individually into `.temp/` files to overcome context limits
- **CI/CD style validation** — uses `validate.ps1` to prevent the AI from skipping steps
- **Modeled on `game-dev-knowledge`** — the gold standard for domain skill structure
- **Progressive disclosure** — SKILL.md provides summaries, `references/` holds details
- **Actionable knowledge** — extracts specific, usable practices, not generic advice
- **Decision-tree navigation** — helps users find the right approach for their specific task
