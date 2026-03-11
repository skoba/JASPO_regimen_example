# レジメンマスタ - Rails規約対応

## テーブル名・カラム名対応表

| 元のテーブル名 | Railsテーブル名 | Railsモデル名 |
|--------------|----------------|--------------|
| code_system | code_systems | CodeSystem |
| drug | drugs | Drug |
| drug_code | drug_codes | DrugCode |
| cancer_type | cancer_types | CancerType |
| cancer_type_code | cancer_type_codes | CancerTypeCode |
| reference_source | reference_sources | ReferenceSource |
| reference_edition | reference_editions | ReferenceEdition |
| regimen_template | regimen_templates | RegimenTemplate |
| timing_code | timing_codes | TimingCode |
| regimen | regimens | Regimen |
| regimen_drug | regimen_drugs | RegimenDrug |
| regimen_drug_schedule | regimen_drug_schedules | RegimenDrugSchedule |
| schedule_timing | schedule_timings | ScheduleTiming |

## 主キーの変更点

| 元のカラム名 | Rails規約 | 備考 |
|------------|----------|------|
| system_id | id | code_systemsは文字列PKを維持 |
| drug_id | id | 自動採番 |
| cancer_type_id | id | 自動採番 |
| source_id | id | 自動採番 |
| edition_id | id | 自動採番 |
| template_id | id | 自動採番 |
| timing_id | id | 自動採番 |
| regimen_id | id | 自動採番 |
| regimen_drug_id | id | 自動採番 |
| schedule_id | id | 自動採番 |

## 外部キーの規約

Rails規約に従い `モデル名_id` 形式を使用:

```
regimen_template_id  → regimen_templates.id
cancer_type_id       → cancer_types.id
reference_edition_id → reference_editions.id
regimen_id           → regimens.id
drug_id              → drugs.id
regimen_drug_id      → regimen_drugs.id
timing_code_id       → timing_codes.id
code_system_id       → code_systems.id  (文字列FK)
```

## カラム名の変更点

| テーブル | 元のカラム名 | Railsカラム名 | 理由 |
|---------|------------|--------------|------|
| code_systems | system_name | name | シンプル化 |
| code_systems | system_uri | uri | シンプル化 |
| reference_sources | source_name | name | シンプル化 |
| regimen_templates | template_name | name | シンプル化 |

## ファイル構成

```
app/
├── models/
│   ├── code_system.rb
│   ├── drug.rb
│   ├── drug_code.rb
│   ├── cancer_type.rb
│   ├── cancer_type_code.rb
│   ├── reference_source.rb
│   ├── reference_edition.rb
│   ├── regimen_template.rb
│   ├── timing_code.rb
│   ├── regimen.rb
│   ├── regimen_drug.rb
│   ├── regimen_drug_schedule.rb
│   └── schedule_timing.rb
│
db/
├── migrate/
│   ├── 20250120000001_create_code_systems.rb
│   ├── 20250120000002_create_drugs.rb
│   ├── 20250120000003_create_drug_codes.rb
│   ├── 20250120000004_create_cancer_types.rb
│   ├── 20250120000005_create_cancer_type_codes.rb
│   ├── 20250120000006_create_reference_sources.rb
│   ├── 20250120000007_create_reference_editions.rb
│   ├── 20250120000008_create_regimen_templates.rb
│   ├── 20250120000009_create_timing_codes.rb
│   ├── 20250120000010_create_regimens.rb
│   ├── 20250120000011_create_regimen_drugs.rb
│   ├── 20250120000012_create_regimen_drug_schedules.rb
│   └── 20250120000013_create_schedule_timings.rb
│
└── seeds.rb
```

## セットアップ手順

```bash
# Railsプロジェクト作成（既存の場合はスキップ）
rails new regimen_master --database=postgresql

# マイグレーション実行
rails db:create
rails db:migrate

# シードデータ投入
rails db:seed
```

## 主要なクエリ例

### PE療法の全バリアントを取得

```ruby
RegimenTemplate.find_by(name: 'PE療法').regimens.includes(:cancer_type, :reference_edition)
```

### 小細胞肺がん 1st lineのレジメン詳細

```ruby
Regimen.by_cancer_type('小細胞肺がん')
       .first_line
       .includes(regimen_drugs: [:drug, regimen_drug_schedules: :schedule_timings])
```

### ICD-10コードからレジメン検索

```ruby
Regimen.by_icd10('C34').includes(:regimen_template, :reference_edition)
```

### 特定薬剤を含むレジメン検索

```ruby
Drug.find_by(generic_name: 'cisplatin').regimens.distinct
```

### 最新版のレジメン一覧

```ruby
source = ReferenceSource.find_by(name: 'がん化学療法レジメンハンドブック')
Regimen.from_latest_edition(source.id).first(10)
```

## FHIR連携

各モデルには `to_fhir_*` メソッドを実装済み:

```ruby
# 薬剤 → FHIR CodeableConcept
drug.to_fhir_codeable_concept

# がん腫 → FHIR CodeableConcept
cancer_type.to_fhir_codeable_concept

# 用量タイミング → FHIR Dosage
schedule_timing.to_fhir_dosage
```

## 注意事項

1. **code_systems テーブル**: 文字列主キー（'YJ', 'HOT'等）を維持。これによりコード参照が直感的に。

2. **タイムスタンプ**: 全テーブルに `created_at`, `updated_at` を自動付与（Rails規約）。

3. **削除時の挙動**:
   - マスタ系: `dependent: :restrict_with_error`（参照があれば削除不可）
   - 詳細系: `dependent: :destroy`（親と一緒に削除）

4. **バリデーション**: モデルレベルで実装済み。DB制約と併用推奨。
