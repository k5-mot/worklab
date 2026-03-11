# Documentation

## Project Overview

- `worklab` は on-premise の開発者向けサービス群を stack 分割で管理する
- 仕様は `doc/spec/*`、設計理由は `doc/design/*`、運用ルールは `doc/rules/*` に分離する
- current service inventory は `doc/spec/*` で管理する

## Reading Order

1. [glossary.md](/workspaces/worklab/doc/glossary.md)
2. [spec/services.md](/workspaces/worklab/doc/spec/services.md)
3. [spec/ports.md](/workspaces/worklab/doc/spec/ports.md)
4. [design/platform-architecture.md](/workspaces/worklab/doc/design/platform-architecture.md)
5. [design/prj-object-storage.md](/workspaces/worklab/doc/design/prj-object-storage.md)
6. [rules/document-style.md](/workspaces/worklab/doc/rules/document-style.md)

## Current Architecture Snapshot

```text
worklab
├── base: Keycloak, OpenBao
├── dev: GitLab EE, GitLab Runner, Kroki, Harbor, SonarQube, Dependency-Track
├── ops: Uptime Kuma, Portainer, Grafana, Prometheus, node-exporter, cAdvisor, Alertmanager, Loki, Tempo
├── prj: Backstage, Outline, Plane, Ghost, SeaweedFS
└── llm: Open WebUI, Ollama, Qdrant, PaddleOCR, SearXNG, Whisper, Kokoro-TTS, ComfyUI, Langfuse, n8n, Dify
```
