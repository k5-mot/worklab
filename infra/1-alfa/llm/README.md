# LLM stack

初回起動時に全サービスを一度に pull すると、Docker Hub / GHCR / Cloudflare CDN への同時接続が増え、`TLS handshake timeout` が起きやすい構成です。

この compose はデフォルトではコア機能のみ起動します。

- デフォルト: `open-webui`, `ollama`, `open-webui-redis`, `open-webui-postgres`, `qdrant`, `searxng`
- `webui-media` profile: `paddleocr`, `whisper`, `kokoro-tts`
- `webui-image` profile: `comfyui`
- `langfuse` profile: `langfuse` 一式
- `n8n` profile: `n8n`
- `dify` profile: `dify` 一式

## 起動例

まずは軽量構成で起動します。

```bash
cd /workspaces/worklab/infra/1-alfa/llm
docker compose up -d
```

追加サービスは profile を指定して段階的に起動します。

```bash
docker compose --profile webui-media up -d
docker compose --profile webui-image up -d
docker compose --profile langfuse up -d
docker compose --profile n8n up -d
docker compose --profile dify up -d
```

回線やレジストリアクセスが不安定な環境では、pull の並列数を落とすと再発しにくくなります。

```bash
cd /workspaces/worklab/infra/1-alfa/llm
COMPOSE_PARALLEL_LIMIT=1 docker compose pull
COMPOSE_PARALLEL_LIMIT=1 docker compose up -d
```

## 公開ポート

- `30040`: Open WebUI
- `30041`: Ollama API
- `30042`: ComfyUI
- `30043`: Langfuse
- `30044`: n8n
- `30045`: Dify
- `30046`: Langfuse MinIO
- `30047`: SearXNG UI
