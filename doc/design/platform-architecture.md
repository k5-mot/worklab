# Design Doc: Platform Architecture

## Context

- `worklab` は on-premise の開発者向けサービス群を運用するためのリポジトリ
- 早期ドラフトには Kubernetes 前提の拡張構想や、より広いサービス候補が含まれていた
- 現在は `base`, `dev`, `obs`, `prj`, `llm` の 5 stack 構成へ収束している

## Goals / Non-goals

- Goals
  - 運用責務ごとに stack を分割する
  - public service と internal service を明確に切り分ける
  - private network 前提で simple な access model を維持する
- Non-goals
  - Kubernetes-first の platform 設計
  - public internet 向け ingress 設計
  - 各サービスの詳細な runtime tuning

## Proposed Design

- `base` に共通基盤を置く
  - Keycloak
  - OpenBao
- `dev` に開発者基盤を置く
  - GitLab EE
  - GitLab Runner
  - Kroki
  - Harbor
  - SonarQube
  - Dependency-Track
- `obs` に監視系を集約する
- `prj` に日常的な project tool を集約する
- `llm` に生成 AI 関連サービスを集約する
- public service だけに固定 host port を割り当てる
- companion service と dependency は親サービスの近くに置き、基本は internal とする

## Alternatives Considered

### Option A: 単一の巨大な compose に集約する

- 利点
  - ファイル数が少ない
- 欠点
  - 運用責務の境界が曖昧になる
  - public/internal の整理が難しくなる

### Option B: 初期メモどおり Kubernetes とデータ基盤まで含める

- 利点
  - 将来構想まで一体で扱える
- 欠点
  - 現在必要な範囲を超えて複雑になる
  - 開発者向け platform という主題がぼやける

## Trade-offs

- stack 分割で見通しは良くなるが、文書数は増える
- private network 前提で設計が単純になるが、internet-facing な構成にはそのまま使えない
- final scope を絞ることで実装しやすくなるが、将来構想は現行仕様から切り離して扱う

## Decision

- `base`, `dev`, `obs`, `prj`, `llm` の 5 stack を採用する
- public host port は `doc/spec/ports.md` で固定する
- service inventory は `doc/spec/services.md` で固定する
- ドラフト文書は整備後に残さず、必要な内容だけを現行文書へ吸収する

## Rollout Plan

- `spec/services.md` と `spec/ports.md` で現行構成を確定する
- stack ごとに compose と運用設定へ落とす

## Monitoring / Observability

- metrics は `Prometheus` と `Grafana`
- availability は `Uptime Kuma`
- logs は `Loki`
- traces は `Tempo`
- alerts は `Alertmanager`

## Security Considerations

- 認証基盤は `Keycloak`
- secret management は `OpenBao`
- internal service は原則 host へ公開しない
- access model は private network 内の `IP + host port` を前提とする
