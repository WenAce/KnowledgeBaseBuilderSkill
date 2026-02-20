# Skill Template — Output Target Structure

The generated domain Skill follows this standard structure, fully matching `game-dev-knowledge`.

## SKILL.md Template

```markdown
---
name: <domain>-knowledge
description: "This skill should be used when the user asks about <domain> topics including <topic1>, <topic2>, <topic3>. Provides comprehensive knowledge from <N> authoritative books/documents."
version: 1.0.0
author: <author>
created: <date>
platforms: [github-copilot-cli, claude-code, codex]
category: knowledge
tags: [<domain>, <tag1>, <tag2>]
risk: safe
---

# <domain>-knowledge

## Purpose

<Brief description: what knowledge this Skill provides from N books, and what work it supports>

## When to Use This Skill

This skill should be invoked when:
- <User scenario 1>
- <User scenario 2>
- <User scenario 3>

## Knowledge Domains

### 1. <Domain Name 1>

**Core Concepts:**

| Concept | Description | When to Apply |
|---------|-------------|---------------|
| <concept1> | <description> | <timing> |
| <concept2> | <description> | <timing> |

**Best Practices:**
- <Specific, actionable practice>
- <Specific, actionable practice>

> **Key Insight (from "<Book Title>"):** <Core insight in 1-2 sentences>

**Reference:** [references/<domain1>.md](references/<domain1>.md)

---

### 2. <Domain Name 2>

... (repeat above structure)

---

## Quick Reference Decision Tree

```
What are you working on?
│
├── <Work scenario 1> → See Domain 1
│   ├── <Sub-problem> → <Solution>
│   └── <Sub-problem> → <Solution>
│
├── <Work scenario 2> → See Domain 2
│   └── ...
│
└── <Work scenario N> → See Domain N
```

## Source Books

All knowledge is distilled from these <N> books:

| Category | Books |
|----------|-------|
| <category1> | <Title> (<pages>p) |
| <category2> | <Title> (<pages>p) |
```

---

## references/\<domain\>.md Template

```markdown
# <Domain Name> — Detailed Reference

## Core Concepts

### <Concept 1>
<Detailed explanation including principles, usage, and caveats>

**Example:**
```
<Code or operation example>
```

### <Concept 2>
...

## Common Problems and Solutions

| Problem | Solution | Source |
|---------|----------|--------|
| <problem1> | <solution1> | <Book Title p.xx> |

## Advanced Patterns

...
```

---

## README.md Template

```markdown
# <domain>-knowledge

A comprehensive knowledge skill for <domain> work, distilled from <N> books.

## Source Books

| Title | Author | Pages | Topics |
|-------|--------|-------|--------|
| <title> | <author> | <pages> | <main topics> |

## How to Use

Invoke this skill when working on any <domain>-related task.
The skill covers: <list of knowledge domains>
```
