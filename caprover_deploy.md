# CapRover Deploy Guide

CapRoverにデプロイする場合、RedisとSearXNG（メインアプリ）を別々の「App」として作成し、安全に連携させる必要があります。

## 1. Redis Appの作成
まず、検索エンジンのキャッシュとレート制限管理に必要なRedisデータベースを用意します。

1. CapRoverのダッシュボードにログイン。
2. **"One-Click Apps"** をクリック。
3. "Redis" を検索して選択。
4. App Nameに `angers-redis` と入力（パスワード等はデフォルトでOK、自動生成されます）。
5. [Deploy] をクリック。
6. デプロイ完了後、`angers-redis` アプリの設定画面を開き、**"Service Address" (例: `srv-captain--angers-redis`)** をメモしておきます。これが内部通信用のアドレスです。

## 2. SearXNG Appの作成
次に、検索エンジン本体のアプリを作成します。

1. ダッシュボードの **"Apps"** に戻り、新しいアプリを作成。
   - Name: `angers-search` (または任意のドメイン)
   - "Has Persistent Data": チェックなしでOK（設定はコード管理するため）
2. 作成されたアプリ (`angers-search`) をクリックして設定画面へ。
3. **"HTTP Settings"** タブを開き、HTTPSを有効化（"Enable HTTPS" -> "Force HTTPS"）。
4. **"App Configs"** タブを開き、環境変数を設定。

### 環境変数の設定 (App Configs)
以下の変数を追加してください。

| Key | Value |
|---|---|
| `SEARXNG_BASE_URL` | https://あなたのドメイン (例: `https://search.kogecha.org`) |
| `SEARXNG_SECRET` | `(ランダムな文字列を設定)` |
| `SEARXNG_REDIS_URL` | `redis://srv-captain--angers-redis:6379/0` (手順1で作成したRedisのアドレス) |
| `UWSGI_WORKERS` | `4` |
| `UWSGI_THREADS` | `4` |

※ `SEARXNG_SETTINGS_PATH` はデフォルト(`/etc/searxng/settings.yml`)でOKです。

## 3. デプロイ方法
以下の2つの方法のどちらかでデプロイします。

### 方法A: Gitリポジトリ経由 (推奨)
1. 作成したファイルをGitHubなどのリポジトリにプッシュ。
2. CapRoverの「Deployment」タブで、リポジトリURL、ブランチ名、ユーザー/パスワードを入力してデプロイ。
   - `captain-definition` ファイルが含まれているため、自動的にCapRoverがビルドを行います。

### 方法B: CapRover CLI (ローカルから直接)
1. ターミナルで `npm install -g caprover` (未インストールの場合)
2. `caprover serversetup` (初回のみ)
3. プロジェクトフォルダ (`/開発/アンガース/`) で `caprover deploy` を実行し、デプロイ先を選択。

## 4. 設定ファイルの更新
検索エンジンの設定 (`searxng/settings.yml`) を変更した場合、再デプロイすることで反映されます。
