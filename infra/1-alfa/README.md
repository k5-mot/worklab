# alfa

## ディレクトリ構成

```bash
1-alfa/
│
├── README.md        ... ランディングページ
│
├── base/            ... 基盤サービス
│   └── docker-compose.yml
├── dev/             ... 開発支援サービス
│   └── docker-compose.yml
├── ops/             ... 運用支援サービス
│   └── docker-compose.yml
├── prj/             ... プロジェクト支援サービス
│   └── docker-compose.yml
└── llm/             ... LLM関連サービス
    └── docker-compose.yml
```

- サービス名の下位 bullet は、self-host 構成で追加になりやすい companion / dependency container を表す
- `or` を含む項目は、同等の役割を持つ代替実装を表す

## 起動方針（リソース制約対応）

`1-alfa/docker-compose.yml` は、検証時の計算資源を抑えるため、常に `base` と追加1スタックのみを起動する構成です。

- 既定: `base + prj`
- 変更方法: `ALFA_STACK_COMPOSE` に `dev/ops/prj/llm` のいずれかを指定

```bash
cd /workspaces/worklab/infra/1-alfa

# 既定 (base + prj)
docker compose up -d

# base + dev
ALFA_STACK_COMPOSE=./dev/docker-compose.yml docker compose up -d

# base + ops
ALFA_STACK_COMPOSE=./ops/docker-compose.yml docker compose up -d

# base + llm
ALFA_STACK_COMPOSE=./llm/docker-compose.yml docker compose up -d
```

停止時は同じ `ALFA_STACK_COMPOSE` 値で `docker compose down` を実行してください。

## 初回セットアップガイド

- base + dev + ops の初回セットアップ手順: `SETUP-base-dev-ops.md`

## base

- Keycloak: `30000`
- OpenBao: `30001`

## dev

- GitLab EE: `30010`
- GitLab Runner
- Kroki
  - kroki-mermaid
  - kroki-bpmn
  - kroki-excalidraw
  - kroki-diagramsnet
- Harbor: `30011`
  - harbor-prepare
  - harbor-log
  - harbor-registry
  - harbor-registryctl
  - harbor-postgresql
  - harbor-core
  - harbor-portal
  - harbor-jobservice
  - harbor-redis
  - harbor-trivy-adapter
- SonarQube: `30012`
- Dependency-Track: `30013`

## ops

- Uptime Kuma: `30020`
- Portainer: `30021`
- Grafana: `30022`
- Prometheus: `30023`
- node-exporter
- cAdvisor
- Alertmanager
- Loki
- Tempo

## prj

- Backstage: `30030`
- Outline: `30031`
  - outline-postgresql
  - outline-redis
  - SeaweedFS
- Plane: `30032`
  - plane-web
  - plane-space
  - plane-admin
  - plane-live
  - plane-api
  - plane-worker
  - plane-beat-worker
  - plane-migrator
  - plane-postgresql
  - plane-valkey
  - plane-rabbitmq
  - SeaweedFS
  - seaweedfs-init
- Ghost: `30033`
- SeaweedFS: `30034`
  - S3-compatible object storage endpoint

## llm

- Open WebUI: `30040`
  - Ollama
- Ollama Init
- Open WebUI Redis
- Open WebUI PostgreSQL
- Ollama: `30041`
- Qdrant
- PaddleOCR
- SearXNG: `30047`
- Whisper
- Kokoro-TTS
- ComfyUI: `30042`
- Langfuse: `30043`
  - langfuse-worker
  - langfuse-clickhouse
  - langfuse-minio: `30046`
  - langfuse-redis
  - langfuse-postgres
- n8n: `30044`
- Dify: `30045`
  - dify-init-permissions
  - dify-api
  - dify-worker
  - dify-worker-beat
  - dify-web
  - dify-db-postgres
  - dify-redis
  - dify-sandbox
  - dify-plugin-daemon
  - dify-ssrf-proxy
  - dify-weaviate
