# LLM stack

このディレクトリは Open WebUI 中心の LLM 開発スタックです。
現行構成は、Vector DB に ChromaDB、ドキュメント抽出に Apache Tika を採用し、Ollama の埋め込みモデルは `nomic-embed-text:latest` に固定しています。

## 構成概要

- デフォルト起動: `open-webui`, `open-webui-redis`, `open-webui-postgres`, `pipelines`, `ollama`, `ollama-init`, `chromadb`, `tika`, `searxng`
- `webui-media` profile: `kokoro-web`, `comfyui`
- `langfuse` profile: `langfuse` 一式
- `n8n` profile: `n8n`
- `dify` profile: `dify` 一式

## 起動手順

1. コア構成を起動

```bash
cd /workspaces/worklab/infra/1-alfa/llm
docker compose up -d
```

2. メディア機能を追加起動

```bash
docker compose --profile webui-media up -d
```

3. 必要に応じて拡張サービスを起動

```bash
docker compose --profile langfuse up -d
docker compose --profile n8n up -d
docker compose --profile dify up -d
```

4. 動作確認

```bash
docker compose ps
docker compose logs --tail=100 open-webui
```

## 運用メモ

- `ollama-init` は bootstrap model と埋め込みモデルを確認し、不足時のみ pull します。
- Vector DB を変更した場合や埋め込み次元を変更した場合は、既存の Knowledge を再インデックスしてください。
- ComfyUI は GPU 版が既定です。CPU 環境向けテンプレートは compose 内にコメントで保持しています。

## 公開ポート

- `3000`: Kokoro Web
- `30040`: Open WebUI
- `30041`: Ollama API
- `30042`: ComfyUI
- `30043`: Langfuse
- `30044`: n8n
- `30045`: Dify
- `30046`: Langfuse MinIO
- `30047`: SearXNG
- `30048`: Apache Tika
- `30049`: ChromaDB
