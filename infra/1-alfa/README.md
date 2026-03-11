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
├── obs/             ... 監視サービス
│   └── docker-compose.yaml
├── prj/             ... プロジェクト支援サービス
│   └── docker-compose.yaml
└── llm/             ... LLM関連サービス
    └── docker-compose.yaml
```

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

## obs

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
- Plane: `30032`
- Ghost: `30033`

## llm

- Open WebUI: `30040`
- Ollama: `30041`
  - Redis
  - PostgreSQL
- Qdrant
- PaddleOCR
- SearXNG
- Whisper
- Kokoro-TTS
- ComfyUI: `30042`
- Langfuse: `30043`
  - Redis
  - PostgreSQL
- n8n: `30044`
- Dify: `30045`
