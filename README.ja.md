[English](README.md) | [中文](README.zh-CN.md) | [日本語](README.ja.md)

# knowledge-base-builder (ナレッジベース・ビルダー)

**メタスキル (Meta-skill)** として機能し、あなたの書籍やドキュメントを機能的な特化型スキルに変換します。`game-dev-knowledge` がゲーム開発をサポートするように、**あらゆる分野**において同等のエキスパートスキルを作成できます。

---

## 機能の概要

```
あなたの書籍/資料          →  knowledge-base-builder   →  ドメイン専門 Skill
(PDF, MD, TXT, DOCX)          (コマンド: generate skill)     (すぐに利用可能)
```

生成されたスキルは `game-dev-knowledge` と同様に機能します。特定ドメインの文脈を理解し、ベストプラクティスを提供し、意思決定ツリーを通じて、あなたの作業に対する専門的なリファレンスとして役立ちます。

---

## クイックスタート

1. **書籍を配置**：資料を `book/` フォルダに置きます (PDF, MD, TXT, DOCX 対応)
2. **コマンドを入力**：`generate skill` と入力します
3. **2つの質問に回答**：AIのプロンプトに従って「ドメイン名」と「主な用途」を答えます
4. **完了**：あなたの専用スキルが `.agent/skills/<domain>-knowledge/` に自動作成されます

---

## トリガーコマンド

| コマンド | アクション |
|---------|--------|
| `generate skill` | 6ステップのスキル生成ワークフローを自動開始します |

---

## 6ステップ・自動ワークフロー

| ステップ | 名称 | 詳細 |
|------|------|--------------|
| 1 | **環境スキャン** | `book/` フォルダをスキャンし、質問をしてから `scaffold.ps1` でディレクトリを構築します |
| 2 | **知識の抽出 (Map)** | **1冊ずつ** 書籍を読み、抽出された内容を `.temp/` フォルダ内の `draft-*.md` として保存します |
| 3 | **構造のプランニング** | ドラフトを統合し、知識ドメイン（分野）と決定ツリーを定義します |
| 4 | **スキルファイルの生成 (Reduce)** | テンプレートに沿って、最終的な `SKILL.md` と `references/*.md` を作成します |
| 5 | **Markdownの同期** | 全てのファイルを `Markdown/<domain>-knowledge/` にコピー・同期します |
| 6 | **検証** | `validate.ps1` を実行し、ファイルや内容の欠落がないかチェックします。失敗した場合は自動修正します。 |

---

## 対応フォーマット

| 拡張子 | 必要なツール | 備考 |
|--------|--------------|-------|
| `.pdf` | `pdf-official` 又は `firecrawl` | 最も機能が豊富です |
| `.md`  | 不要 | ドキュメントやメモに最適・推奨フォーマット |
| `.txt` | 不要 | 常に読み込み可能 |
| `.docx`| `docx` スキル | Word ドキュメント用 |

もしPDF読み込みツールがない場合は、テキストを直接貼り付けるようAIからプロンプトが表示されます。

---

## 生成される構造

生成完了後、以下のような構造のファイルツリーが出力されます：

```
.agent/skills/<domain>-knowledge/
├── SKILL.md            ← メインファイル：領域定義と決定ツリーを含む
├── README.md           ← 参考書籍リストと利用ガイド
└── references/
    ├── <domain1>.md    ← 分野 1 の詳細な知識とベストプラクティス
    ├── <domain2>.md    ← 分野 2 の詳細な知識とベストプラクティス
    └── ...

Markdown/<domain>-knowledge/   ← 同期された閲覧用のコピー
```

生成されたスキルは `game-dev-knowledge` の設計を踏襲しています：
- **知識ドメイン (Knowledge Domains)** — テーマごとに整理された概念とベストプラクティス
- **重要な洞察 (Key Insights)** — 各書籍からの画期的な考え方
- **決定ツリー (Decision Tree)** — 「今何をしているか？ → 分野Xを参照せよ」というナビゲーション
- **ソース書籍 (Source Books)** — 参照した資料の完全なリスト

---

## 生成例（英語での対話例）

```
User: generate skill

AI: book/ フォルダをスキャンしています...
    発見: physics-textbook.pdf, chemistry-notes.md, biology-guide.txt

    質問:
    1. ドメイン名は何ですか？ → "Life Sciences"
    2. 主な利用シナリオは？ → "文献レビュー、実験設計、ラボのトラブルシューティング"

AI: 知識を抽出中...
    [3つのドメインを特定: 生物学、化学、実験方法]

    構造を計画しています: life-sciences-knowledge
    ファイルを生成中...
    ✓ .agent/skills/life-sciences-knowledge/SKILL.md
    ✓ .agent/skills/life-sciences-knowledge/references/biology.md
    ✓ .agent/skills/life-sciences-knowledge/references/chemistry.md
    ...
    Markdown/life-sciences-knowledge/ への同期 ✓

    検証中... → 完了！
```

---

## ファイルリファレンス

| ファイル | 目的 |
|------|---------|
| [`SKILL.md`](SKILL.md) | メインスキルエントリー（6ステップのフロー） |
| [`scripts/scaffold.ps1`](scripts/scaffold.ps1) | 初期フォルダ構造を生成するセットアップスクリプト |
| [`scripts/validate.ps1`](scripts/validate.ps1) | CI/CD スタイルの整合性チェックスクリプト |
| [`book/README.md`](book/README.md) | `book/` フォルダの利用ガイド |
| [`references/pdf-tools.md`](references/pdf-tools.md) | PDFツールの検出とフォールバック戦略 |
| [`references/skill-template.md`](references/skill-template.md) | 生成されるスキルの標準テンプレート |
| [`references/knowledge-extraction.md`](references/knowledge-extraction.md) | 知識抽出の手法ガイド |

---

## 設計思想

- **Map-Reduce ステート管理** — 文脈（コンテキスト）の制限を越えるため、書籍を個別に `.temp/` に読み込んでから統合します
- **自動化された整合性検証** — `validate.ps1` を用いて、ステップのスキップ（手抜き）を防止します
- **`game-dev-knowledge` を踏襲** — ドメインスキルの「黄金基準」である既存のモデルをベースに設計
- **段階的な情報開示** — `SKILL.md` に要約を配置し、詳細は `references/` に隔離します
- **実践的知識の抽出** — 表面的なアドバイスではなく、実務で使えるアクション可能な指標に絞ります
- **決定ツリーナビゲーション** — 作業中のタスクに直結する適切なアプローチへとユーザーを導きます
