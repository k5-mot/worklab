# Design Doc: Project Stack Object Storage

## Context

- `Plane` は self-host 構成で S3-compatible storage を前提にできる
- `Outline` も self-host 構成で S3-compatible storage を利用できる
- `worklab` は stack ごとに compose を分割し、public/internal を明確に扱う
- `prj` stack には object storage の標準実装がまだない

## Goals / Non-goals

- Goals
  - `prj` stack に S3-compatible storage の標準実装を置く
  - `Plane` と `Outline` が参照できる object storage endpoint を固定する
  - `private network` 前提でも browser upload に使えるよう host port を固定する
- Non-goals
  - `Dify` まで同時に storage backend を統一すること
  - object lifecycle や backup policy の詳細設計
  - multi-node な `SeaweedFS` cluster 設計

## Proposed Design

- `prj` stack に `SeaweedFS` を追加する
- `SeaweedFS` は `S3-compatible object storage` として扱う
- `SeaweedFS` には public host port `30034` を割り当てる
- `Plane` と `Outline` の標準 storage endpoint は `SeaweedFS` とする
- `SeaweedFS Init` で `Plane` と `Outline` の bucket を bootstrap する
- 初期実装は single-container の `SeaweedFS` で開始する

## Alternatives Considered

### Option A: `MinIO` を標準にする

- 利点
  - AWS S3 互換性が高い
  - browser upload 系の実績が多い
- 欠点
  - `Plane` 以外も含めた platform 標準としては柔軟性が限定される
  - `SeaweedFS` に比べると small-file 前提の拡張余地が狭い

### Option B: 外部の managed S3 を前提にする

- 利点
  - compose が軽くなる
  - storage 運用を外出しできる
- 欠点
  - on-premise 前提の `worklab` と相性が悪い
  - local stack だけで閉じた検証ができない

## Trade-offs

- `SeaweedFS` は `S3-compatible` だが、AWS S3 完全互換を前提にはできない
- `Plane` と `Outline` の用途には適合しやすいが、`Harbor` のような registry workload へ即座に横展開する判断は保留する
- public port を 1 つ増やす代わりに browser upload と service discovery を単純にできる

## Decision

- `prj` stack の object storage は `SeaweedFS` を採用する
- `SeaweedFS` は `Plane` と `Outline` の標準 storage endpoint とする
- public host port は `30034` を割り当てる
- 他 stack への横展開は別判断に分離する

## Follow-up Decision

- `Outline` も `SeaweedFS` を S3-compatible storage として利用する
- `SeaweedFS Init` は `Plane` と `Outline` の bucket bootstrap を担当する
- `Outline` 向けに `Outline PostgreSQL` と `Outline Redis` を `prj` stack へ追加する
