# JASPO Regimen Master - Rails 8.1.2

がん化学療法レジメンハンドブックをベースにしたレジメンのコード化と関連テーブル、マスタ類を管理するRailsアプリケーションです。

## 環境要件

- Ruby 3.4.0以上
- Rails 8.1.2
- PostgreSQL 13以上

## セットアップ

### 1. リポジトリのクローン

```bash
git clone <repository-url>
cd rails_regimen_master
```

### 2. 依存関係のインストール

```bash
bundle install
```

### 3. データベースのセットアップ

PostgreSQLのユーザーとデータベースを作成してください：

```bash
# PostgreSQLにログイン
sudo -u postgres psql

# ユーザーとデータベースの作成
CREATE USER rails_regimen WITH PASSWORD 'your_password';
CREATE DATABASE rails_regimen_master_development OWNER rails_regimen;
CREATE DATABASE rails_regimen_master_test OWNER rails_regimen;
```

または、`config/database.yml`を編集して既存のPostgreSQLユーザーを使用してください。

### 4. データベースのマイグレーションとシードデータ投入

```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

## データベース構造

詳細は[rails_schema_overview.md](rails_schema_overview.md)を参照してください。

### 主要テーブル

- **code_systems**: コード体系（YJ、HOT、ICD-10など）
- **drugs**: 薬剤マスタ
- **drug_codes**: 薬剤コード
- **cancer_types**: がん腫マスタ
- **cancer_type_codes**: がん腫コード
- **reference_sources**: 出典（書籍・ガイドライン）
- **reference_editions**: 出典の版
- **regimen_templates**: レジメンテンプレート
- **regimens**: レジメン（がん腫・治療ラインごと）
- **regimen_drugs**: レジメンで使用される薬剤
- **regimen_drug_schedules**: 投与スケジュール
- **timing_codes**: 投与タイミングコード
- **schedule_timings**: 具体的な投与タイミング

## 使用例

### Railsコンソールでのデータ確認

```bash
bin/rails console
```

```ruby
# PE療法の全バリアントを取得
RegimenTemplate.find_by(name: 'PE療法').regimens.includes(:cancer_type, :reference_edition)

# 小細胞肺がんの1次治療レジメン
Regimen.by_cancer_type('小細胞肺がん').first_line

# ICD-10コードからレジメン検索
Regimen.by_icd10('C34')

# 特定薬剤を含むレジメン検索
Drug.find_by(generic_name: 'cisplatin').regimens.distinct
```

## テスト

RSpecを使用してテストを実行：

```bash
bundle exec rspec
```

## サンプルデータ

シードデータ（`bin/rails db:seed`）で以下のレジメンがセットアップされます：

### レジメンテンプレート（12種類）

1. **PE療法** - Cisplatin + Etoposide（小細胞肺がん、精巣腫瘍）
2. **S-1単独療法** - Tegafur/Gimeracil/Oteracil 単剤（胃がん）
3. **FOLFOX療法** - Oxaliplatin + Fluorouracil + Leucovorin（大腸がん）
4. **FOLFIRI療法** - Irinotecan + Fluorouracil + Leucovorin（大腸がん）
5. **AC療法** - Doxorubicin + Cyclophosphamide（乳がん）
6. **TC療法** - Docetaxel + Cyclophosphamide（乳がん）
7. **XELOX療法** - Capecitabine + Oxaliplatin（胃がん）
8. **GC療法** - Gemcitabine + Cisplatin（膀胱がん）
9. **カルボプラチン+パクリタキセル療法**（卵巣がん）
10. **CHOP療法**（悪性リンパ腫）
11. **R-CHOP療法**（悪性リンパ腫）
12. **ペムブロリズマブ単独療法**（非小細胞肺がん）

**合計**: 13レジメン、18薬剤、10がん腫

## FHIR連携

各モデルには`to_fhir_*`メソッドが実装されており、FHIR形式でのデータ出力が可能です：

```ruby
# 薬剤 → FHIR CodeableConcept
drug.to_fhir_codeable_concept

# がん腫 → FHIR CodeableConcept
cancer_type.to_fhir_codeable_concept

# 用量タイミング → FHIR Dosage
schedule_timing.to_fhir_dosage
```

## ライセンス

MIT License

## 貢献

バグ報告や機能追加のプルリクエストを歓迎します。
