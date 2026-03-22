# base + dev + ops 初回セットアップ

この手順は、`1-alfa` の現行方針である「`base + 追加1スタック`」を守りながら、`base`/`dev`/`ops` の初回セットアップを順番に完了するためのガイドです。

## 0. 前提

- Docker / Docker Compose が利用可能であること
- 実行ディレクトリ: `infra/1-alfa`
- 永続ボリュームは `docker compose down` では削除されないため、スタックを切り替えても初期設定は保持されます

```bash
cd /home/merry/repos/worklab/infra/1-alfa
```

## 0.1 最初にアクセスする URL 一覧

初回セットアップ時にアクセスする主な URL は次の通りです。

- Keycloak Admin: http://localhost:30000/admin/
- OpenBao UI: http://localhost:30001/ui/
- Infisical Signup: http://localhost:30002/admin/signup
- GitLab: http://localhost:30010
- Harbor (任意): http://localhost:30011
- SonarQube (任意): http://localhost:30012
- Dependency-Track (任意): http://localhost:30013
- Uptime Kuma: http://localhost:30020
- Portainer: http://localhost:30021
- Grafana: http://localhost:30022
- Prometheus: http://localhost:30023
- Keycloak Realm OIDC Discovery: http://localhost:30000/realms/worklab/.well-known/openid-configuration

## 1. 推奨: `.env` を作成して初期認証情報を固定

未指定でもデフォルト値で起動できますが、初回から明示値を使うことを推奨します。

```bash
cat > .env << 'EOF'
KEYCLOAK_ADMIN=admin
KEYCLOAK_ADMIN_PASSWORD=change-me-keycloak
OPENBAO_DEV_ROOT_TOKEN_ID=change-me-openbao-root-token
INFISICAL_POSTGRES_PASSWORD=change-me-infisical-postgres
EOF
```

## 2. base + dev を起動して基盤と開発系を初期化

```bash
ALFA_STACK_COMPOSE=./dev/docker-compose.yml docker compose up -d
docker compose ps
```

### 2.1 Keycloak 初期ログイン

- URL: http://localhost:30000/admin/
- 初期ユーザー: `.env` の `KEYCLOAK_ADMIN`
- 初期パスワード: `.env` の `KEYCLOAK_ADMIN_PASSWORD`
- 初回ログイン後に管理者パスワードを変更

### 2.1.1 Keycloak を IdP として運用する手順 (OIDC)

この環境では Keycloak を認証基盤 (IdP) とし、各サービスを OIDC クライアントとして連携します。

1. Realm を作成または選択

- アクセス先: http://localhost:30000/admin/
- `master` は管理用に残し、業務用 Realm (例: `worklab`) を作成

2. ユーザー/グループを作成

- アクセス先: http://localhost:30000/admin/　ｂ
- `Users` で利用者を作成
- `Groups` で権限グループを作成 (例: `platform-admin`, `developer`, `viewer`)

3. サービスごとに Client を作成

- アクセス先: http://localhost:30000/admin/
- Realm `worklab` -> `Clients` -> `Create client`
- `Client type`: `OpenID Connect`
- `Client authentication`: `On` (confidential client)
- `Valid redirect URIs` と `Web origins` をサービスURLに合わせて設定
- 作成後に `Client ID` / `Client Secret` を各サービス設定へ反映

4. トークンの Mapper を設定

- `Client scopes` / `Mappers` で `email`, `preferred_username`, `groups` を含める
- サービス側のロール連携が必要な場合は `groups` または `realm roles` を付与

5. Keycloak 側の動作確認

- OpenID Configuration: http://localhost:30000/realms/worklab/.well-known/openid-configuration
- Account Console: http://localhost:30000/realms/worklab/account

### 2.1.2 各サービスを Keycloak に連携する時の URL 早見表

以下は、各サービス側に OIDC 設定を入れる際に使う URL です。

- Issuer: `http://localhost:30000/realms/worklab`
- Authorization endpoint: `http://localhost:30000/realms/worklab/protocol/openid-connect/auth`
- Token endpoint: `http://localhost:30000/realms/worklab/protocol/openid-connect/token`
- UserInfo endpoint: `http://localhost:30000/realms/worklab/protocol/openid-connect/userinfo`
- JWKS endpoint: `http://localhost:30000/realms/worklab/protocol/openid-connect/certs`

代表的な Redirect URI 例:

- Grafana (`http://localhost:30022`) の場合: `http://localhost:30022/login/generic_oauth`
- Harbor (`http://localhost:30011`) の場合: `http://localhost:30011/c/oidc/callback`
- SonarQube (`http://localhost:30012`) の場合: `http://localhost:30012/oauth2/callback/oidc`

注記:

- 上記 Redirect URI はサービス設定に依存するため、実際のバージョン/プラグイン仕様に合わせて最終確認してください。
- GitLab はこの手順では IdP として使いません (通常アプリ利用のみ)。

### 2.2 OpenBao 初期アクセス

- URL: http://localhost:30001/ui/
- Token: `.env` の `OPENBAO_DEV_ROOT_TOKEN_ID`
- この構成は `server -dev` のため開発向けです。本番用途では別構成に切り替えてください

### 2.3 Infisical オーナー作成

- URL: http://localhost:30002/admin/signup
- 初回アクセス時に管理者アカウントを作成
- 作成後、Organization 名と Owner アカウントを確定

### 2.4 GitLab root 初期ログイン

- URL: http://localhost:30010
- ユーザー: `root`
- 初期パスワード取得:

```bash
docker exec worklab-alfa-dev-gitlab cat /etc/gitlab/initial_root_password
```

- ログイン後に root パスワード変更

### 2.5 Harbor (任意) を初期化

`dev` では Harbor は profile サービスです。必要時のみ起動します。

```bash
ALFA_STACK_COMPOSE=./dev/docker-compose.yml docker compose --profile harbor up -d
```

- URL: http://localhost:30011
- 初期ユーザー: `admin`
- 初期パスワード: `Harbor12345` (定義: `dev/harbor/input/harbor.yml`)
- 初回ログイン後に admin パスワード変更

### 2.6 SonarQube / Dependency-Track (任意) を初期化

`security` profile を有効化した場合のみ起動します。

```bash
ALFA_STACK_COMPOSE=./dev/docker-compose.yml docker compose --profile security up -d
```

- SonarQube URL: http://localhost:30012
  - 初期ユーザー: `admin`
  - 初期パスワード: `admin`
  - 初回ログイン時に変更が求められます
- Dependency-Track URL: http://localhost:30013
  - 初回管理者ログイン情報はバージョンで差異があるため、ログイン画面表示に従って設定

## 3. base + ops を起動して運用系を初期化

一度停止してから切り替えます。

```bash
ALFA_STACK_COMPOSE=./dev/docker-compose.yml docker compose down
ALFA_STACK_COMPOSE=./ops/docker-compose.yml docker compose up -d
docker compose ps
```

### 3.1 Uptime Kuma 管理者作成

- URL: http://localhost:30020
- 初回アクセスで管理者アカウント作成

### 3.2 Portainer 管理者作成

- URL: http://localhost:30021
- 初回アクセスで admin パスワード設定
- Environment は `local` (Docker socket) を選択

### 3.3 Grafana 初期ログイン

- URL: http://localhost:30022
- 初期ユーザー: `admin`
- 初期パスワード: `admin`
- 初回ログイン後にパスワード変更

### 3.4 Prometheus 確認

- URL: http://localhost:30023
- `Status -> Targets` で scrape 対象が `UP` になっていることを確認

### 3.5 Tempo (任意)

トレースが必要な場合のみ起動します。

```bash
ALFA_STACK_COMPOSE=./ops/docker-compose.yml docker compose --profile ops-tracing up -d
```

## 4. 動作確認コマンド (HTTP)

```bash
curl -I http://127.0.0.1:30000
curl -I http://127.0.0.1:30001
curl -I http://127.0.0.1:30002
curl -I http://127.0.0.1:30010
curl -I http://127.0.0.1:30020
curl -I http://127.0.0.1:30021
curl -I http://127.0.0.1:30022
curl -I http://127.0.0.1:30023
```

## 5. 停止

```bash
ALFA_STACK_COMPOSE=./ops/docker-compose.yml docker compose down
```

必要に応じて再び `base + dev` へ戻す場合は、`ALFA_STACK_COMPOSE=./dev/docker-compose.yml` で同様に起動してください。
