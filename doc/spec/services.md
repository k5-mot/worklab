# Service Catalog

## Context

- この文書は `worklab` の current service inventory を定義する Living Spec
- 役割、公開区分、dependency を整理して service inventory を固定する

## Goals

- stack ごとの service inventory を定義する
- 各サービスの役割と公開区分を明確にする
- companion service と dependency を区別する

## Non-goals

- image tag の固定
- 環境変数や volume の詳細設計
- 技術選定理由の説明

## Behavior

### Functional Requirements

#### base

| Service | Role | Exposure | Notes |
| --- | --- | --- | --- |
| Keycloak | identity provider | public | host port `30000` |
| OpenBao | secret management | public | host port `30001` |

#### dev

| Service | Role | Exposure | Notes |
| --- | --- | --- | --- |
| GitLab EE | source control and CI entrypoint | public | host port `30010` |
| GitLab Runner | CI execution worker | internal | GitLab 専用 worker |
| Kroki | diagram rendering gateway | internal | companion 群を束ねる |
| kroki-mermaid | Kroki companion | internal | Mermaid renderer |
| kroki-bpmn | Kroki companion | internal | BPMN renderer |
| kroki-excalidraw | Kroki companion | internal | Excalidraw renderer |
| kroki-diagramsnet | Kroki companion | internal | diagrams.net renderer |
| Harbor | container registry | public | host port `30011` |
| SonarQube | code quality | public | host port `30012` |
| Dependency-Track | SBOM and dependency risk | public | host port `30013` |

#### obs

| Service | Role | Exposure | Notes |
| --- | --- | --- | --- |
| Uptime Kuma | uptime monitoring UI | public | host port `30020` |
| Portainer | container management UI | public | host port `30021` |
| Grafana | visualization UI | public | host port `30022` |
| Prometheus | metrics collection | public | host port `30023` |
| node-exporter | host metrics exporter | internal | scrape target |
| cAdvisor | container metrics exporter | internal | scrape target |
| Alertmanager | alert routing | internal | notification hub |
| Loki | log aggregation | internal | logging backend |
| Tempo | trace aggregation | internal | tracing backend |

#### prj

| Service | Role | Exposure | Notes |
| --- | --- | --- | --- |
| Backstage | developer portal | public | host port `30030` |
| Outline | knowledge base | public | host port `30031` |
| Plane | project management | public | host port `30032` |
| Ghost | publishing and documentation | public | host port `30033` |

#### llm

| Service | Role | Exposure | Notes |
| --- | --- | --- | --- |
| Open WebUI | LLM UI | public | host port `30040` |
| Ollama | model runtime API | public | host port `30041` |
| Redis | Ollama dependency | internal | service-local dependency |
| PostgreSQL | Ollama dependency | internal | service-local dependency |
| Qdrant | vector store | internal or undecided | public exposure 未確定 |
| PaddleOCR | OCR | internal or undecided | public exposure 未確定 |
| SearXNG | search meta engine | internal or undecided | public exposure 未確定 |
| Whisper | speech-to-text | internal or undecided | public exposure 未確定 |
| Kokoro-TTS | text-to-speech | internal or undecided | public exposure 未確定 |
| ComfyUI | image generation UI | public | host port `30042` |
| Langfuse | LLM observability | public | host port `30043` |
| Redis | Langfuse dependency | internal | service-local dependency |
| PostgreSQL | Langfuse dependency | internal | service-local dependency |
| n8n | workflow automation | public | host port `30044` |
| Dify | LLM application platform | public | host port `30045` |

### Non-functional Requirements

- サービス名は repository 全体で一貫させる
- public/internal 区分は `spec/ports.md` の固定 port 有無で決める
- 1 サービス 1 行で扱い、hidden service を作らない

### User Flow

- 運用者は stack を選ぶ
- 該当サービスの role と exposure を確認する
- public service の場合は [ports.md](/workspaces/worklab/doc/spec/ports.md) を参照する

### Constraints

- service inventory の変更時はこの文書を先に更新する
- public service の変更時は `spec/ports.md` も同時に更新する
- dependency と companion service は親サービスの補助用途に限定する

## Acceptance Criteria

- current service inventory の全サービスがこの文書に反映されている
- public host port を持つサービスはすべて `public` として扱われている
- service inventory と `spec/ports.md` の public service が矛盾していない

## Open Questions

- `Qdrant`, `PaddleOCR`, `SearXNG`, `Whisper`, `Kokoro-TTS` の public exposure は未確定
- `obs` stack の internal service を host 公開する必要が将来出るかは未確定
