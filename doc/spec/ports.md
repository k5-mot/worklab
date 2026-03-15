# Public Port Allocation

## Context

- この文書は `worklab` の public host port を一覧化した Living Spec
- service discovery と port collision 防止を目的とする

## Goals

- public host port を stack ごとに固定する
- internal service と public service を明確に分離する
- 新規ポート追加時の更新順序を明確にする

## Non-goals

- container port や reverse proxy 設計の定義
- TLS、DNS、ingress の設計
- port の選定理由の記録

## Behavior

### Functional Requirements

| Stack | Service          | Public Host Port |
| ----- | ---------------- | ---------------: |
| base  | Keycloak         |            30000 |
| base  | OpenBao          |            30001 |
| base  | Infisical        |            30002 |
| dev   | GitLab EE        |            30010 |
| dev   | Harbor           |            30011 |
| dev   | SonarQube        |            30012 |
| dev   | Dependency-Track |            30013 |
| ops   | Uptime Kuma      |            30020 |
| ops   | Portainer        |            30021 |
| ops   | Grafana          |            30022 |
| ops   | Prometheus       |            30023 |
| prj   | Backstage        |            30030 |
| prj   | Outline          |            30031 |
| prj   | Plane            |            30032 |
| prj   | Ghost            |            30033 |
| prj   | SeaweedFS        |            30034 |
| llm   | Kokoro Web       |             3000 |
| llm   | Open WebUI       |            30040 |
| llm   | Ollama           |            30041 |
| llm   | ComfyUI          |            30042 |
| llm   | Langfuse         |            30043 |
| llm   | n8n              |            30044 |
| llm   | Dify             |            30045 |
| llm   | Langfuse MinIO   |            30046 |
| llm   | SearXNG          |            30047 |
| llm   | Apache Tika      |            30048 |
| llm   | ChromaDB         |            30049 |

### Non-functional Requirements

- port block は stack 単位でまとまりを持たせる
- 同一 port を複数サービスへ割り当てない
- `spec/services.md` に存在しないサービスへ固定 port を与えない

### User Flow

- 運用者は service 名から public host port を引く
- port が見つからない場合は internal service とみなす
- port を追加したい場合は `spec/services.md` とこの文書を同時に更新する

### Constraints

- public host port の正本はこの文書
- この文書単独では service を新設できない
- internal service の公開判断は `spec/services.md` とセットで確定する

## Acceptance Criteria

- `spec/services.md` の public service がすべてこの表に存在する
- table に `spec/services.md` 由来でない port が存在しない
- internal service は table に含めない

## Open Questions

- `ops` stack の internal service に外部 UI を設けるかは未確定
- `SeaweedFS` を `prj` 以外の stack でも共通利用するかは未確定
