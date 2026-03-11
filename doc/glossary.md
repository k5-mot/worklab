# 用語集

## Living Spec

- 定義：現在の正しい振る舞いを記述する上書き更新可能な仕様文書
- 使用箇所：
  - [spec/services.md](/workspaces/worklab/doc/spec/services.md)
  - [spec/ports.md](/workspaces/worklab/doc/spec/ports.md)
- 注意事項：
  - 設計理由や技術選定理由は含めない

## Stack

- 定義：運用責務で束ねたサービス群
- 使用箇所：
  - [spec/services.md](/workspaces/worklab/doc/spec/services.md)
  - [design/platform-architecture.md](/workspaces/worklab/doc/design/platform-architecture.md)
- 注意事項：
  - `base`, `dev`, `obs`, `prj`, `llm` の 5 種を使う

## Public Host Port

- 定義：ホストから直接到達できる公開ポート
- 使用箇所：
  - [spec/ports.md](/workspaces/worklab/doc/spec/ports.md)
  - [spec/services.md](/workspaces/worklab/doc/spec/services.md)
- 注意事項：
  - `spec/ports.md` に明記されたものだけを固定値として扱う

## Public Service

- 定義：Public Host Port を持ち、ホストから直接到達できるサービス
- 使用箇所：
  - [spec/services.md](/workspaces/worklab/doc/spec/services.md)
  - [spec/ports.md](/workspaces/worklab/doc/spec/ports.md)
- 注意事項：
  - public かどうかは port の固定有無で判定する

## Internal Service

- 定義：stack 内部で利用し、host へ直接公開しないサービス
- 使用箇所：
  - [spec/services.md](/workspaces/worklab/doc/spec/services.md)
- 注意事項：
  - 公開方法が未決定なサービスも暫定的にこの分類に含める

## Companion Service

- 定義：単独ではなく親サービスを補助するために置くサービス
- 使用箇所：
  - [spec/services.md](/workspaces/worklab/doc/spec/services.md)
- 注意事項：
  - `Kroki` 配下の companion 群が代表例

## Service-Local Dependency

- 定義：特定サービスの成立に必要な補助的なデータストアや周辺サービス
- 使用箇所：
  - [spec/services.md](/workspaces/worklab/doc/spec/services.md)
- 注意事項：
  - `Ollama` と `Langfuse` の `Redis` / `PostgreSQL` を含む
