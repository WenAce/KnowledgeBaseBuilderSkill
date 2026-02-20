# Knowledge Extraction Methodology

Standard methods for extracting knowledge from books and documents during Step 2.

## 1. Identify Knowledge Domain Categories

After reading all books, look for recurring **topic clusters**:

```
Ask: What major themes appear repeatedly across these books?
→ Each major theme = one knowledge domain

Example (game development):
  Physics/Collision × 3 books  → "Physics & Collision" domain
  AI Behavior × 4 books        → "Game AI" domain
  Engine Structure × 2 books   → "Engine Architecture" domain
```

**Recommended domain count:**
- 1~3 books  → 2~3 domains
- 4~7 books  → 3~5 domains
- 8+ books   → 5~6 domains (cap at 6)

---

## 2. Extract Key Insights

For each book, find the most valuable insights:

```
Format:
> **Key Insight (from "<Book Title>"):** <core insight in 1-2 sentences>

Principles:
- Insights should be "counterintuitive" or "high-density value" information
- Not generic advice, but specific techniques or discoveries
- Always attribute to the source book
```

**Example (from game-dev-knowledge):**
> **Key Insight (from "Practical Game AI Programming"):** Simple AI with well-designed personality creates a stronger player experience than complex but soulless AI.

---

## 3. Build the Decision Tree

The decision tree is the core navigation tool of the Skill:

```
Construction principles:
1. First level: User's work task ("What am I doing?")
2. Second level: Specific problem type
3. Leaf nodes: Solutions / recommended approaches

Format:
What are you working on?
│
├── <Work scenario> → See Domain X
│   ├── <Sub-problem A> → <Specific method>
│   └── <Sub-problem B> → <Another method>
```

---

## 4. Extract Best Practices

Extract **actionable** best practices from books (avoid vague statements):

```
❌ Bad practice: Pay attention to performance
✓ Good practice: Use Object Pool to pre-allocate frequently created/destroyed objects (bullets, particles)

❌ Bad practice: Design it properly
✓ Good practice: Use SLERP instead of LERP for rotation interpolation to avoid gimbal lock
```

---

## 5. Compile Book References

In the Source Books table at the end of SKILL.md, organize by knowledge domain:

```markdown
| Category  | Books |
|-----------|-------|
| AI Behavior   | Practical Game AI Programming (399p) |
| Collision     | Real-Time Collision Detection (423p)  |
```

---

## 6. Knowledge Domain Detail Files (references/)

Generate one `references/<domain>.md` per domain with deeper content than SKILL.md:
- Complete algorithm explanations
- Code examples
- Problem/solution comparison tables
- In-depth principle analysis

SKILL.md contains only summaries; detailed content goes into references/ (progressive disclosure).
