[English](README.md) | [中文](README.zh-CN.md) | [日本語](README.ja.md)

# knowledge-base-builder (知识库生成器)

一个**元技能 (Meta-skill)**，可以将你的书籍和文档转化为功能完整的领域专属技能 —— 就像 `game-dev-knowledge` 辅助游戏开发工作一样，你可以为**任何领域**生成等效的专属专家技能。

---

## 它的作用

```
你的书籍/文档        →  knowledge-base-builder  →  领域专家 Skill
(PDF, MD, TXT)          (口令: generate skill)          (即开即用)
```

生成的 Skill 运作方式与 `game-dev-knowledge` 相同：它能理解领域上下文，提供最佳实践，辅助决策，并在你处理该领域的任何任务时作为专家级的参考字典。

---

## 快速开始

1. **放入你的书籍**：将资料放置到 `book/` 文件夹下 (支持 PDF, MD, TXT, DOCX)
2. **输入触发口令**：`generate skill` 或 `生成skill`
3. **回答提示问题**：根据界面提示回答 2 个简单问题
4. **完成**：你的领域专属 Skill 将被自动生成并在 `.agent/skills/<domain>-knowledge/` 就绪

---

## 触发口令

| 口令 | 行为 |
|---------|--------|
| `generate skill` 或 `生成skill` | 启动完整的 6 步生成工作流 |

---

## 6 步自动化工作流

| 步骤 | 名称 | 执行动作 |
|------|------|--------------|
| 1 | **环境扫描** | 扫描 `book/` 目录，询问 2 个问题，并执行 `scaffold.ps1` 构建目标目录树 |
| 2 | **知识提取 (Map)** | **逐本**读取书籍，将提取的中间结果 `draft-*.md` 文件保存至 `.temp/` 目录 |
| 3 | **结构规划** | 将所有的草稿综合提炼，划定知识领域并生成决策树 |
| 4 | **生成技能文件 (Reduce)** | 将提炼内容填入模板，生成最终的 `SKILL.md` 和 `references/*.md` 文件 |
| 5 | **同步镜像副本** | 自动将所有生成的文件同步复制到 `Markdown/<domain>-knowledge/` 以便查阅 |
| 6 | **验证与测试** | 运行 `validate.ps1` 校验是否所有内容均被正确填充。如失败则强制修复。 |

---

## 支持的输入格式

| 格式 | 前置依赖插件 | 备注 |
|--------|--------------|-------|
| `.pdf` | `pdf-official` 或 `firecrawl` 技能 | 功能最强 |
| `.md`  | 无 | 极力推荐，最适合笔记和总结 |
| `.txt` | 无 | 永远可读 |
| `.docx` | `docx` 技能 | 适用于 Word 文档 |

如果未检测到可用的 PDF 阅读工具，系统会回退提示你直接粘贴文本内容。

---

## 产出结构

流程结束后，你将获得如下结构的文件树：

```
.agent/skills/<domain>-knowledge/
├── SKILL.md            ← 核心主干：包含知识领域划分和决策树指引
├── README.md           ← 包含书籍来源列表以及使用说明
└── references/
    ├── <domain1>.md    ← 领域 1 的详细知识点和最佳实践
    ├── <domain2>.md    ← 领域 2 的详细知识点和最佳实践
    └── ...

Markdown/<domain>-knowledge/   ← 自动同步的查阅用副本
```

生成的技能严格对标 `game-dev-knowledge`，包括：
- **知识域 (Knowledge Domains)** — 分门别类的核心概念和最佳实践
- **核心洞察 (Key Insights)** — 原作者的顶级思路
- **决策树 (Decision Tree)** — "正在处理 X 任务？ → 请前往参考领域 Y"
- **来源书目 (Source Books)** — 完整的资料溯源表

---

## 生成范例

```
User: 生成skill

AI: 正在扫描 book/ 文件夹...
    找到: physics-textbook.pdf, chemistry-notes.md, biology-guide.txt

    未检测到 pdf-official 技能。
    可读取: chemistry-notes.md, biology-guide.txt
    无法读取: physics-textbook.pdf → 稍后会要求你手动提供摘要

    请问:
    1. 生成的领域名称是？ → "生命科学 (Life Sciences)"
    2. 主要用于哪些工作场景？ → "文献预研, 实验设计, 实验室问题排查"

AI: 正在从 2 个可用文件中提取知识...
    [识别到 3 个知识领域: 基础生物学, 化学分析, 实验方法论]
    [用户提供了物理摘要 → 合并到知识提取中]

    正在规划技能树的结构: life-sciences-knowledge
    生成文件中...
    ✓ .agent/skills/life-sciences-knowledge/SKILL.md
    ✓ .agent/skills/life-sciences-knowledge/references/biology.md
    ✓ .agent/skills/life-sciences-knowledge/references/chemistry.md
    ✓ .agent/skills/life-sciences-knowledge/references/lab-methods.md
    ✓ .agent/skills/life-sciences-knowledge/README.md
    正在同步至 Markdown/life-sciences-knowledge/ ✓

    校验验证中: 测试 "如何设计对照实验？" → ✓ 成功由新生成的技能解答
    构建完成！
```

---

## 文件参考

| 文件 | 描述 |
|------|---------|
| [`SKILL.md`](SKILL.md) | 主技能入口 — 统领完整 6 步工作流 |
| [`scripts/scaffold.ps1`](scripts/scaffold.ps1) | 初始化脚手架脚本：负责一键生成目标目录树 |
| [`scripts/validate.ps1`](scripts/validate.ps1) | CI/CD 风格约束脚本：验证所有内容是否被正确生成 |
| [`book/README.md`](book/README.md) | `book/` 目录的书籍放置指南 |
| [`references/pdf-tools.md`](references/pdf-tools.md) | PDF 工具自动检测与优雅降解策略 |
| [`references/skill-template.md`](references/skill-template.md) | 生成专属技能时所需要的标准模板 |
| [`references/knowledge-extraction.md`](references/knowledge-extraction.md) | AI 知识提炼方法论指导 |

---

## 核心设计理念

- **基于 Map-Reduce 的状态管理** — 强制 AI 每次只读一本书，生成独立 `.temp/` 临时文件，完美解决上下文爆存和跳步骤问题
- **CI/CD 强制校验** — 通过 `validate.ps1` 打断 AI 的偷懒路径
- **向游戏开发技能看齐** — 模板与备受好评的 `game-dev-knowledge` 保持一致
- **渐进式细节披露** — SKILL.md 只放骨架和提纲，具体的细节代码全在 `references/` 里
- **可落地的知识** — 只提取切实可用的最佳实践，不要虚头巴脑的泛泛而谈
- **决策树导航** — 将实际业务场景与相应的文档建立映射，帮助你做业务选择
