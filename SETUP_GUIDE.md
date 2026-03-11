# セットアップガイド

このドキュメントでは、がん化学療法レジメンマスタアプリケーションのセットアップ手順を説明します。

## 前提条件

- Ruby 3.4.0以上がインストールされていること
- PostgreSQL 13以上がインストールされていること
- Bundler がインストールされていること

## セットアップ手順

### 1. 依存関係のインストール

プロジェクトディレクトリで以下を実行：

```bash
bundle install
```

### 2. PostgreSQLの設定

#### オプションA: 新しいPostgreSQLユーザーとデータベースを作成

```bash
# PostgreSQLにログイン
sudo -u postgres psql

# PostgreSQLで以下のコマンドを実行
CREATE USER rails_regimen WITH PASSWORD 'your_secure_password';
CREATE DATABASE rails_regimen_master_development OWNER rails_regimen;
CREATE DATABASE rails_regimen_master_test OWNER rails_regimen;

# 権限の付与
GRANT ALL PRIVILEGES ON DATABASE rails_regimen_master_development TO rails_regimen;
GRANT ALL PRIVILEGES ON DATABASE rails_regimen_master_test TO rails_regimen;

# 終了
\q
```

その後、`config/database.yml`のコメントを解除して、ユーザー名とパスワードを設定：

```yaml
development:
  <<: *default
  database: rails_regimen_master_development
  username: rails_regimen
  password: your_secure_password
  host: localhost
```

#### オプションB: 既存のPostgreSQLユーザーを使用

`config/database.yml`を編集して、既存のユーザー情報を設定します。

#### オプションC: 環境変数を使用

以下の環境変数を設定：

```bash
export DATABASE_USER=your_username
export DATABASE_PASSWORD=your_password
export DATABASE_HOST=localhost
```

### 3. データベースの作成とマイグレーション

```bash
# データベースの作成
bin/rails db:create

# マイグレーションの実行
bin/rails db:migrate

# サンプルデータの投入（オプション）
bin/rails db:seed
```

### 4. 動作確認

#### Railsコンソールでの確認

```bash
bin/rails console
```

コンソール内で以下を実行：

```ruby
# データベース接続の確認
ActiveRecord::Base.connection.active?
# => true

# サンプルデータの確認（db:seedを実行した場合）
CodeSystem.count
# => 6

Drug.count
# => 3

Regimen.count
# => 3

# PE療法のレジメンを確認
RegimenTemplate.find_by(name: 'PE療法').regimens.each do |r|
  puts "#{r.full_name} - #{r.ordered_drugs.count}種の薬剤"
end
```

#### Railsサーバーの起動

```bash
bin/rails server
```

ブラウザで `http://localhost:3000/up` にアクセスして、ヘルスチェックが通ることを確認します。

### 5. テストの実行（オプション）

RSpecのセットアップとテスト実行：

```bash
# RSpecの初期化（初回のみ）
bin/rails generate rspec:install

# テストの実行
bundle exec rspec
```

## トラブルシューティング

### データベース接続エラー

```
PG::ConnectionBad: FATAL: database "rails_regimen_master_development" does not exist
```

**解決方法**: `bin/rails db:create`を実行してデータベースを作成してください。

### 認証エラー

```
PG::ConnectionBad: FATAL: password authentication failed for user "rails_regimen"
```

**解決方法**: `config/database.yml`のユーザー名とパスワードが正しいか確認してください。

### マイグレーションエラー

```
ActiveRecord::PendingMigrationError
```

**解決方法**: `bin/rails db:migrate`を実行してください。

## 次のステップ

セットアップが完了したら、以下のドキュメントを参照してください：

- [README.md](README.md) - プロジェクトの概要と使用例
- [rails_schema_overview.md](rails_schema_overview.md) - データベーススキーマの詳細

## サポート

問題が発生した場合は、プロジェクトのIssueトラッカーで報告してください。
