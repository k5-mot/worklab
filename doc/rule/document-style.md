# Documentation Style Guide

- 基本思想として、Docs-as-Codeを志向し、コーディングエージェントライクなドキュメント管理を目指す
- Google式ドキュメント設計思想をベースに、ディレクトリ構成とルールを定義する
- 可能な限り、日本語を使用する
- タイトル・見出しで英語を使う場合、「<英語> / <日本語>」のように両言語併記とする
- 可能な限り、ドキュメント同士の記述の重複がないように書くこと

## ディレクトリ構成・責務

```bash
(root)
│
├── README.md                           ... 概要、ディレクトリ構成、ドキュメントの読む順番、全体像、ライセンス
│
├── doc/
│   │
│   ├── README.md                       ... ランディングページ
│   ├── glossary.md                     ... 用語集
│   │
│   ├── assets/                         ... ドキュメント向け画像・図など
│   │
│   ├── plan/                           ... 実行前の計画・移行計画
│   │   ├── frontend-refactor-plan.md   ... (例)フロントエンドリファクタリングの計画
│   │   └── ...
│   │
│   ├── spec/                           ... Living Spec (WHATを重視)
│   │   ├── auth.md                     ... (例)認証・認可の仕様
│   │   ├── billing.md                  ... (例)課金の仕様
│   │   ├── <featurue-a>/               ... 機能ごとにファイルを分ける
│   │   │   ├── <sub-feature-a1>.md     ... サブ機能ごとにさらに分けることもある
│   │   │   └── <sub-feature-a2>.md
│   │   └── ...
│   │
│   ├── design/                         ... Design Doc (WHYを重視)
│   │   ├── frontend.md                 ... フロントエンド全体の設計
│   │   ├── backend.md                  ... バックエンド全体の設計
│   │   ├── infra.md                    ... インフラ全体の設計
│   │   ├── devenv.md                   ... 開発環境全体の設計
│   │   └── ...
│   │
│   ├── manual/                         ... 操作マニュアル
│   │   ├── setup.md                    ... 開発環境セットアップ手順
│   │   ├── deployment.md               ... デプロイ手順
│   │   ├── runbook.md                  ... 障害対応手順
│   │   └── ...
│   │
│   ├── rule/                           ... 開発規約
│   │   ├── document-style.md           ... ドキュメントスタイルガイド
│   │   ├── git-workflow.md             ... Git運用ルール
│   │   ├── review-policy.md            ... コードレビューポリシー
│   │   └── ...
│   │
│   └── llms-txt/                       ... LLM向けコンテキスト
│
├── frontend/                           ... フロントエンドプロジェクト (monorepo)
│   └── README.md                       ... 環境変数、開発手順、トラブルシューティング
│
└── backend/                            ... バックエンドプロジェクト (monorepo)
    └── README.md                       ... 環境変数、開発手順、トラブルシューティング
```

## 基本記述ルール

- 簡潔に書く
- 箇条書きを優先
- glossary用語を使用
- AIフレンドリーな構造を意識
  - 1ファイル1トピック
  - 明確な見出し
  - セクションを小さく

## ランディングページ(doc/README.md)の役割

`doc/README.md`には、「読む順番」と「全体像」だけを書く。

- 含むべき内容：
  - プロジェクト概要
  - ドキュメントの読む順番
  - 現在のアーキテクチャの全体構成図
- 含まない内容：
  - 詳細仕様
  - 設計議論・選定理由

> [!NOTE] ADR
> Document navigationを`doc/README.md`に集約する.
>
> - 階層が深くなると、探索コストが増えるため
> - IA(情報設計)として、shallow hierarchy が強い
> - AI参照でも root landing が最適
>

## 用語集(doc/glossary.md)の役割

`doc/glossary.md`は、ドメイン用語の唯一の定義場所とする。

### doc/glossary.mdの記述形式

```text
# 用語集

## <用語>

- 定義：<用語の定義>
- 使用箇所：
  - <用語が使用されているドキュメントへのパス>
- 注意事項：
  - <用語の注意事項>
```

> [!NOTE] ADR
> Document navigationを`doc/README.md`に集約する.
>
> - ubiquitous language
> - semantic anchor
> - AI推論安定
>

## Spec Doc(doc/spec/*)の役割

- 目的
  - システムが「何をするか」を定義する仕様書
  - 正しい振る舞いの記述
- 特徴
  - Living documentであり、常に現在の正解を反映する
  - 上書き更新を許容する
- 記述する内容
  - 背景 (Context)
  - 目標 (Goals)
  - 非目標 (Non-goals)
  - 振る舞い (Behavior)
    - 機能要件 (Functional requirements)
    - 非機能要件 (Non-functional requirements)
    - ユーザーフロー (User Flow)
    - 制約条件 (Constraints)
  - 受け入れ基準 (Acceptance Criteria)
  - 未解決の課題 (Open Questions)
- 記述を禁止する内容
  - Architecture decision
  - 技術選択理由

## Design Doc（doc/design/*）

- 目的
  - システムが「なぜその設計を採用したか」を記録する設計書
- 特徴
  - 過去の設計判断を保持するため、append-onlyとする
  - Option framingを活用し、複数のOptionsとそのTrade-offsを明確にする
  - SSOT(Single Source of Truth)を保つため、要求仕様を書かない
- 記述する内容
  - 推奨設計 (Proposed Design)
  - 代替案 (Alternatives)
  - トレードオフ (Trade-offs)
  - 決定事項 (Decision)
    - ADR (Architecture Decision Record)
    - RFC (Request for Comments)
- 記述を禁止する内容
  - 要求仕様の定義
