# ops

## GitLab - Grafanaセットアップ手順

このリポジトリでは Grafana の data source と GitLab ダッシュボードは provisioning 済みです。  
GitLab メトリクスを Grafana で見えるようにするには、`dev` 側 GitLab の exporter を `ops` 側 Prometheus から scrape できるようにします。

### 事前に入っているもの

- Grafana data source: `infra/1-alfa/ops/grafana/datasources.yml`
- Grafana dashboard provider: `infra/1-alfa/ops/grafana/default.yaml`
- GitLab dashboard JSON: `infra/1-alfa/ops/grafana/dashboards/gitlab.json`

このため、Grafana で手動 import は不要です。

### 前提

- GitLab: `http://localhost:30010`
- Grafana: `http://localhost:30022`
- Prometheus: `http://localhost:30023`
- `infra/1-alfa/dev/docker-compose.yml` と `infra/1-alfa/ops/docker-compose.yml` は別 Compose project
- そのままでは `ops` 側 Prometheus から `dev` 側 GitLab を service 名で名前解決できない

以下の手順では、GitLab と Prometheus を同じ external network に参加させます。

### 1. 共有 network を作成する

```bash
docker network create worklab-alfa-monitoring
```

既に存在する場合はそのままで構いません。

### 2. GitLab と Prometheus を同じ network に参加させる

`infra/1-alfa/dev/docker-compose.yml` の `gitlab` service を次のように更新します。

```yaml
services:
  gitlab:
    volumes:
      - gitlab-config:/etc/gitlab
      - gitlab-logs:/var/log/gitlab
      - gitlab-data:/var/opt/gitlab
      - ./gitlab/omnibus_config.rb:/etc/gitlab/omnibus_config.rb:ro
    networks:
      - dev-public
      - dev-internal
      - monitoring

networks:
  dev-public:
  dev-internal:
  monitoring:
    external: true
    name: worklab-alfa-monitoring
```

`infra/1-alfa/ops/docker-compose.yml` の `prometheus` service を次のように更新します。

```yaml
services:
  prometheus:
    networks:
      - ops-public
      - ops-internal
      - monitoring

networks:
  ops-public:
  ops-internal:
  monitoring:
    external: true
    name: worklab-alfa-monitoring
```

`infra/1-alfa/dev/gitlab/omnibus_config.rb` は現状 bind mount されていないため、この mount を追加しないとローカルの変更が GitLab コンテナへ反映されません。

### 3. GitLab exporter を外部 Prometheus 向けに有効化する

`infra/1-alfa/dev/gitlab/omnibus_config.rb` に次を追加するか、該当箇所のコメントを外します。

```ruby
# GitLab 内蔵 Prometheus は使わず、ops 側 Prometheus に集約する
prometheus['enable'] = false

# External Prometheus から scrape できるように exporter を待ち受ける
gitlab_workhorse['prometheus_listen_addr'] = "0.0.0.0:9229"

gitlab_exporter['enable'] = true
gitlab_exporter['listen_address'] = '0.0.0.0'
gitlab_exporter['listen_port'] = '9168'

sidekiq['metrics_enabled'] = true
sidekiq['listen_address'] = '0.0.0.0'
sidekiq['listen_port'] = 8082

# GitLab UI から外部 Prometheus を参照したい場合だけ設定する
# gitlab_rails['prometheus_address'] = 'worklab-alfa-ops-prometheus:9090'
```

補足:

- `prometheus_monitoring['enable']` は `false` にしません
- この dashboard では `gitlab-workhorse` と `sidekiq` と `gitlab_exporter` を scrape すれば最低限表示できます
- Puma の web exporter (`8083`) はこの dashboard では未使用なので必須ではありません

### 4. Prometheus に GitLab scrape target を追加する

提示されたサンプルの形に寄せると、`infra/1-alfa/ops/prometheus/prometheus.yml` は次のイメージになります。  
このリポジトリには `nginx-exporter` は無いため、その target は入れていません。

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

alerting:
  alertmanagers:
    - scheme: http
      static_configs:
        - targets:
            - alertmanager:9093

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets:
          - worklab-alfa-ops-prometheus:9090

  - job_name: 'node'
    static_configs:
      - targets:
          - worklab-alfa-ops-node-exporter:9100
          - worklab-alfa-ops-cadvisor:8080

  - job_name: 'gitlab-workhorse'
    static_configs:
      - targets:
          - worklab-alfa-dev-gitlab:9229

  - job_name: 'gitlab-sidekiq'
    static_configs:
      - targets:
          - worklab-alfa-dev-gitlab:8082

  - job_name: 'gitlab_exporter'
    static_configs:
      - targets:
          - worklab-alfa-dev-gitlab:9168
```

補足:

- `worklab-alfa-ops-prometheus` / `worklab-alfa-ops-node-exporter` / `worklab-alfa-ops-cadvisor` は、このリポジトリの `container_name` に合わせた名前です
- `gitlab-workhorse` という job 名は、`infra/1-alfa/ops/grafana/dashboards/gitlab.json` のクエリに合わせています
- サンプルのように `job_name: 'gitlab'` で `worklab-alfa-dev-gitlab:9090` を scrape すると、取得対象は GitLab 内蔵 Prometheus 自身のメトリクスになります
- 今ある `gitlab.json` ダッシュボードは `workhorse` / `sidekiq` / `gitlab_exporter` 系のメトリクスを前提にしているため、この README では exporter を個別に scrape する構成にしています

### 5. コンテナを再作成して設定を反映する

```bash
docker compose -f infra/1-alfa/dev/docker-compose.yml up -d gitlab
docker exec worklab-alfa-dev-gitlab gitlab-ctl reconfigure

docker compose -f infra/1-alfa/ops/docker-compose.yml up -d prometheus grafana
```

GitLab 側の exporter 起動確認:

```bash
docker exec worklab-alfa-dev-gitlab ss -lnt | grep -E '9168|9229|8082'
```

### 6. 動作確認

1. `http://localhost:30023/targets` を開く
2. `gitlab-workhorse` / `gitlab-sidekiq` / `gitlab_exporter` が `UP` になっていることを確認する
3. `http://localhost:30022` を開く
4. `GitLab JiHu - Overview` ダッシュボードを開く

### トラブルシュート

- `worklab-alfa-dev-gitlab` を名前解決できない  
  `worklab-alfa-monitoring` に GitLab と Prometheus の両方が参加しているか確認します。

- Prometheus target が `DOWN` のまま  
  `gitlab-ctl reconfigure` 後に exporter が listen しているか、`ss -lnt` で確認します。

- Grafana に dashboard が出ない  
  `infra/1-alfa/ops/grafana/default.yaml` と `infra/1-alfa/ops/grafana/dashboards/gitlab.json` が mount されているか確認し、必要なら Grafana を再作成します。

- GitLab 側の monitoring を全部止めてしまった  
  `prometheus_monitoring['enable'] = false` にすると exporter まで止まるため、external Prometheus 構成では設定しません。

### 参考

- GitLab Docs: Monitoring GitLab with Prometheus  
  https://docs.gitlab.com/administration/monitoring/prometheus/
- GitLab Docs: Web exporter  
  https://docs.gitlab.com/administration/monitoring/prometheus/web_exporter/
- GitLab Docs: Sidekiq metrics server  
  https://docs.gitlab.com/administration/sidekiq/
