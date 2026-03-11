# alfa

## ディレクトリ構成

```bash
1-alfa/
│
├── README.md        ... ランディングページ
│
├── base/            ... 基盤サービス
│   └── docker-compose.yaml
├── dev/             ... 開発支援サービス
│   └── docker-compose.yaml
├── ops/             ... 運用支援サービス
│   └── docker-compose.yaml
├── prj/             ... プロジェクト支援サービス
│   └── docker-compose.yaml
└── llm/             ... LLM関連サービス
    └── docker-compose.yaml
```

- サービス名の下位 bullet は、self-host 構成で追加になりやすい companion / dependency container を表す
- `or` を含む項目は、同等の役割を持つ代替実装を表す

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
- Ollama: `30041`
  - ollama-redis
  - ollama-postgres
- Qdrant
- PaddleOCR
- SearXNG
- Whisper
- Kokoro-TTS
- ComfyUI: `30042`
- Langfuse: `30043`
  - langfuse-redis
  - langfuse-postgres
- n8n: `30044`
- Dify: `30045`
