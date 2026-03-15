# Base stack

このディレクトリは認証・シークレット管理の基盤サービスを提供します。

## 構成概要

- keycloak: ID 管理 (host port 30000)
- openbao: シークレット管理 (host port 30001)
- infisical: シークレット管理 UI/API (host port 30002)
- infisical-redis: Infisical キャッシュ
- infisical-postgres: Infisical データベース

## 起動手順

1. 起動

```bash
cd /workspaces/worklab/infra/1-alfa/base
docker compose up -d
```

2. 状態確認

```bash
docker compose ps
docker compose logs --tail=100
```

3. 停止

```bash
docker compose down
```

## 公開ポート

- 30000: Keycloak
- 30001: OpenBao
- 30002: Infisical
