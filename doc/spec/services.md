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

| Service              | Role                              | Exposure | Notes                    |
| -------------------- | --------------------------------- | -------- | ------------------------ |
| Keycloak             | identity provider                 | public   | host port `30000`        |
| OpenBao              | secret management                 | public   | host port `30001`        |
| Infisical            | secret management platform UI/API | public   | host port `30002`        |
| Infisical Redis      | Infisical cache backend           | internal | service-local dependency |
| Infisical PostgreSQL | Infisical relational database     | internal | service-local dependency |

#### dev

| Service              | Role                             | Exposure | Notes                                               |
| -------------------- | -------------------------------- | -------- | --------------------------------------------------- |
| GitLab EE            | source control and CI entrypoint | public   | host port `30010`                                   |
| GitLab Runner        | CI execution worker              | internal | GitLab 専用 worker                                  |
| Kroki                | diagram rendering gateway        | internal | companion 群を束ねる                                |
| kroki-mermaid        | Kroki companion                  | internal | Mermaid renderer                                    |
| kroki-bpmn           | Kroki companion                  | internal | BPMN renderer                                       |
| kroki-excalidraw     | Kroki companion                  | internal | Excalidraw renderer                                 |
| kroki-diagramsnet    | Kroki companion                  | internal | diagrams.net renderer                               |
| Harbor               | container registry               | public   | host port `30011`                                   |
| Harbor Prepare       | Harbor config generation job     | internal | one-shot job for official Harbor config and secrets |
| Harbor Log           | Harbor log collector             | internal | syslog endpoint for Harbor components               |
| Harbor Registry      | Harbor image registry            | internal | official Harbor registry service                    |
| Harbor Registryctl   | Harbor registry control plane    | internal | official Harbor companion                           |
| Harbor PostgreSQL    | Harbor relational database       | internal | service-local dependency                            |
| Harbor Core          | Harbor backend API               | internal | official Harbor companion                           |
| Harbor Portal        | Harbor UI container              | internal | official Harbor companion                           |
| Harbor Jobservice    | Harbor async worker              | internal | official Harbor companion                           |
| Harbor Redis         | Harbor cache backend             | internal | service-local dependency                            |
| Harbor Trivy Adapter | Harbor vulnerability scanner     | internal | official Harbor companion                           |
| SonarQube            | code quality                     | public   | host port `30012`                                   |
| Dependency-Track     | SBOM and dependency risk         | public   | host port `30013`                                   |

#### ops

| Service       | Role                       | Exposure | Notes             |
| ------------- | -------------------------- | -------- | ----------------- |
| Uptime Kuma   | uptime monitoring UI       | public   | host port `30020` |
| Portainer     | container management UI    | public   | host port `30021` |
| Grafana       | visualization UI           | public   | host port `30022` |
| Prometheus    | metrics collection         | public   | host port `30023` |
| node-exporter | host metrics exporter      | internal | scrape target     |
| cAdvisor      | container metrics exporter | internal | scrape target     |
| Alertmanager  | alert routing              | internal | notification hub  |
| Loki          | log aggregation            | internal | logging backend   |
| Tempo         | trace aggregation          | internal | tracing backend   |

#### prj

| Service            | Role                           | Exposure | Notes                                                        |
| ------------------ | ------------------------------ | -------- | ------------------------------------------------------------ |
| Backstage          | developer portal               | public   | host port `30030`                                            |
| Outline            | knowledge base                 | public   | host port `30031`, uses `SeaweedFS` as S3-compatible storage |
| Outline PostgreSQL | Outline relational database    | internal | service-local dependency                                     |
| Outline Redis      | Outline cache backend          | internal | service-local dependency                                     |
| Plane              | project management             | public   | host port `30032`, proxy entrypoint for Plane UI and API     |
| Plane Web          | Plane frontend UI              | internal | Plane companion                                              |
| Plane Space        | Plane space UI                 | internal | Plane companion                                              |
| Plane Admin        | Plane admin UI                 | internal | Plane companion                                              |
| Plane Live         | Plane realtime server          | internal | Plane companion                                              |
| Plane API          | Plane backend API              | internal | Plane companion                                              |
| Plane Worker       | Plane async worker             | internal | Plane companion                                              |
| Plane Beat Worker  | Plane scheduled worker         | internal | Plane companion                                              |
| Plane Migrator     | Plane database migrator        | internal | Plane companion                                              |
| Plane PostgreSQL   | Plane relational database      | internal | service-local dependency                                     |
| Plane Valkey       | Plane cache backend            | internal | service-local dependency                                     |
| Plane RabbitMQ     | Plane message broker           | internal | service-local dependency                                     |
| Ghost              | publishing and documentation   | public   | host port `30033`                                            |
| SeaweedFS          | S3-compatible object storage   | public   | host port `30034`, `Plane` and `Outline` storage endpoint    |
| SeaweedFS Init     | SeaweedFS bucket bootstrap job | internal | creates `Plane` and `Outline` upload buckets                 |

#### llm

| Service               | Role                           | Exposure | Notes                                                     |
| --------------------- | ------------------------------ | -------- | --------------------------------------------------------- |
| Open WebUI            | LLM UI                         | public   | host port `30040`                                         |
| Ollama                | model runtime API              | public   | host port `30041`                                         |
| Ollama Init           | Ollama bootstrap job           | internal | one-shot job that preloads bootstrap and embedding models |
| Open WebUI Redis      | Open WebUI cache backend       | internal | service-local dependency                                  |
| Open WebUI PostgreSQL | Open WebUI relational database | internal | service-local dependency                                  |
| Open WebUI Pipelines  | Open WebUI pipeline runtime    | internal | Open WebUI companion                                      |
| ChromaDB              | vector store                   | public   | host port `30049`, Open WebUI vector backend              |
| Apache Tika           | document extraction server     | public   | host port `30048`, Open WebUI content extraction backend  |
| SearXNG               | search meta engine UI          | public   | host port `30047`                                         |
| Kokoro Web            | text-to-speech API             | public   | host port `3000`, OpenAI-compatible TTS endpoint          |
| ComfyUI               | image generation UI            | public   | host port `30042`                                         |
| Langfuse              | LLM observability              | public   | host port `30043`                                         |
| Langfuse Worker       | Langfuse async worker          | internal | official Langfuse companion                               |
| Langfuse ClickHouse   | Langfuse analytics store       | internal | service-local dependency                                  |
| Langfuse MinIO        | Langfuse object storage        | public   | host port `30046`, S3 endpoint for Langfuse uploads       |
| Langfuse Redis        | Langfuse dependency            | internal | service-local dependency                                  |
| Langfuse PostgreSQL   | Langfuse dependency            | internal | service-local dependency                                  |
| n8n                   | workflow automation            | public   | host port `30044`                                         |
| Dify                  | LLM application platform       | public   | host port `30045`                                         |
| Dify Init Permissions | Dify storage bootstrap job     | internal | one-shot job for app storage permissions                  |
| Dify API              | Dify backend API               | internal | official Dify companion                                   |
| Dify Worker           | Dify async worker              | internal | official Dify companion                                   |
| Dify Worker Beat      | Dify scheduler                 | internal | official Dify companion                                   |
| Dify Web              | Dify frontend UI               | internal | official Dify companion                                   |
| Dify PostgreSQL       | Dify relational database       | internal | service-local dependency                                  |
| Dify Redis            | Dify cache backend             | internal | service-local dependency                                  |
| Dify Sandbox          | Dify code execution sandbox    | internal | official Dify companion                                   |
| Dify Plugin Daemon    | Dify plugin runtime            | internal | official Dify companion                                   |
| Dify SSRF Proxy       | Dify outbound proxy            | internal | official Dify companion                                   |
| Dify Weaviate         | Dify vector store              | internal | official Dify default vector backend                      |

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

- `ops` stack の internal service を host 公開する必要が将来出るかは未確定
- `Dify` の object storage を `SeaweedFS` へ統一するかは未確定
- `Harbor` の generated config を repository 管理へ寄せるか、runtime generation のままにするかは未確定
