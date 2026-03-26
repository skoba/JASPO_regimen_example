# frozen_string_literal: true

# db/seeds.rb
# レジメンマスタ サンプルデータ

puts 'Seeding database...'

# ==========================================
# コード体系
# ==========================================
puts '  Creating code systems...'

code_systems = [
  { id: 'YJ',    name: '薬価基準収載医薬品コード', uri: 'urn:oid:1.2.392.100495.20.2.71', version: '2024' },
  { id: 'HOT',   name: 'HOTコード',              uri: 'urn:oid:1.2.392.100495.20.2.74', version: '2024' },
  { id: 'ATC',   name: 'ATC分類',                uri: 'http://www.whocc.no/atc', version: '2024' },
  { id: 'ICD10', name: 'ICD-10',                 uri: 'http://hl7.org/fhir/sid/icd-10', version: '2019' },
  { id: 'ICDO3', name: 'ICD-O-3',                uri: 'http://terminology.hl7.org/CodeSystem/icd-o-3', version: '2019' },
  { id: 'MEDIS', name: 'MEDIS病名マスタ',         uri: 'urn:oid:1.2.392.200119.4.101.2', version: '2024' }
]

code_systems.each do |cs|
  CodeSystem.find_or_create_by!(id: cs[:id]) do |record|
    record.name = cs[:name]
    record.uri = cs[:uri]
    record.version = cs[:version]
  end
end

# ==========================================
# 薬剤
# ==========================================
puts '  Creating drugs...'

drugs_data = [
  {
    generic_name: 'cisplatin',
    brand_name: 'ランダ',
    abbreviation: 'CDDP',
    codes: [
      { system: 'YJ',  code: '4291401A1027', display: 'シスプラチン注50mg' },
      { system: 'HOT', code: '1078453010101', display: 'シスプラチン点滴静注液50mg' },
      { system: 'ATC', code: 'L01XA01', display: 'cisplatin' }
    ]
  },
  {
    generic_name: 'etoposide',
    brand_name: 'ベプシド',
    abbreviation: 'ETP',
    codes: [
      { system: 'YJ',  code: '4240403A1034', display: 'エトポシド注100mg' },
      { system: 'ATC', code: 'L01CB01', display: 'etoposide' }
    ]
  },
  {
    generic_name: 'tegafur/gimeracil/oteracil',
    brand_name: 'ティーエスワン',
    abbreviation: 'S-1',
    codes: [
      { system: 'YJ', code: '4229104F1022', display: 'ティーエスワン配合カプセルT20' }
    ]
  }
]

drugs = {}
drugs_data.each do |data|
  drug = Drug.find_or_create_by!(generic_name: data[:generic_name]) do |d|
    d.brand_name = data[:brand_name]
    d.abbreviation = data[:abbreviation]
  end
  drugs[data[:generic_name]] = drug

  data[:codes].each do |code_data|
    DrugCode.find_or_create_by!(
      drug: drug,
      code_system_id: code_data[:system],
      code: code_data[:code]
    ) do |dc|
      dc.display = code_data[:display]
    end
  end
end

# ==========================================
# がん腫
# ==========================================
puts '  Creating cancer types...'

cancer_types_data = [
  {
    name: '肺がん',
    codes: [
      { system: 'ICD10', code: 'C34', display: '気管支及び肺の悪性新生物' },
      { system: 'ICDO3', code: 'C34.9', display: 'Lung, NOS' }
    ]
  },
  {
    name: '小細胞肺がん',
    codes: [
      { system: 'ICD10', code: 'C34', display: '気管支及び肺の悪性新生物' },
      { system: 'ICDO3', code: '8041/3', display: 'Small cell carcinoma, NOS' }
    ]
  },
  {
    name: '胃がん',
    codes: [
      { system: 'ICD10', code: 'C16', display: '胃の悪性新生物' }
    ]
  },
  {
    name: '精巣腫瘍',
    codes: [
      { system: 'ICD10', code: 'C62', display: '精巣の悪性新生物' }
    ]
  }
]

cancer_types = {}
cancer_types_data.each do |data|
  ct = CancerType.find_or_create_by!(name: data[:name])
  cancer_types[data[:name]] = ct

  data[:codes].each do |code_data|
    CancerTypeCode.find_or_create_by!(
      cancer_type: ct,
      code_system_id: code_data[:system],
      code: code_data[:code]
    ) do |ctc|
      ctc.display = code_data[:display]
    end
  end
end

# ==========================================
# 出典・版
# ==========================================
puts '  Creating reference sources and editions...'

handbook = ReferenceSource.find_or_create_by!(name: 'がん化学療法レジメンハンドブック') do |rs|
  rs.source_type = 'book'
  rs.publisher = '羊土社'
  rs.isbn = '978-4-7581-1234-5'
end

edition_7 = ReferenceEdition.find_or_create_by!(
  reference_source: handbook,
  edition_number: '第7版'
) do |re|
  re.publication_date = Date.new(2020, 3, 1)
  re.effective_date = Date.new(2020, 4, 1)
end

edition_8 = ReferenceEdition.find_or_create_by!(
  reference_source: handbook,
  edition_number: '第8版'
) do |re|
  re.publication_date = Date.new(2023, 3, 1)
  re.effective_date = Date.new(2023, 4, 1)
end

# ==========================================
# レジメンテンプレート
# ==========================================
puts '  Creating regimen templates...'

pe_template = RegimenTemplate.find_or_create_by!(name: 'PE療法') do |rt|
  rt.description = 'Cisplatin + Etoposide'
end

s1_template = RegimenTemplate.find_or_create_by!(name: 'S-1単独療法') do |rt|
  rt.description = 'Tegafur/Gimeracil/Oteracil 単剤'
end

# ==========================================
# 投与タイミング
# ==========================================
puts '  Creating timing codes...'

timing_codes_data = [
  { code: 'MORN',  display: '朝',     fhir_when_code: 'MORN',  sort_order: 1 },
  { code: 'AFT',   display: '昼',     fhir_when_code: 'AFT',   sort_order: 2 },
  { code: 'EVE',   display: '夕',     fhir_when_code: 'EVE',   sort_order: 3 },
  { code: 'NIGHT', display: '就寝前', fhir_when_code: 'NIGHT', sort_order: 4 },
  { code: 'AC',    display: '食前',   fhir_when_code: 'AC',    sort_order: 10 },
  { code: 'PC',    display: '食後',   fhir_when_code: 'PC',    sort_order: 11 },
  { code: 'ACM',   display: '朝食前', fhir_when_code: 'ACM',   sort_order: 20 },
  { code: 'PCM',   display: '朝食後', fhir_when_code: 'PCM',   sort_order: 21 },
  { code: 'ACD',   display: '昼食前', fhir_when_code: 'ACD',   sort_order: 22 },
  { code: 'PCD',   display: '昼食後', fhir_when_code: 'PCD',   sort_order: 23 },
  { code: 'ACV',   display: '夕食前', fhir_when_code: 'ACV',   sort_order: 24 },
  { code: 'PCV',   display: '夕食後', fhir_when_code: 'PCV',   sort_order: 25 }
]

timing_codes = {}
timing_codes_data.each do |data|
  tc = TimingCode.find_or_create_by!(code: data[:code]) do |t|
    t.display = data[:display]
    t.fhir_when_code = data[:fhir_when_code]
    t.sort_order = data[:sort_order]
  end
  timing_codes[data[:code]] = tc
end

# ==========================================
# レジメン
# ==========================================
puts '  Creating regimens...'

# PE療法（小細胞肺がん）
pe_sclc = Regimen.find_or_create_by!(
  regimen_template: pe_template,
  cancer_type: cancer_types['小細胞肺がん'],
  reference_edition: edition_8,
  line_of_therapy: '1st'
) do |r|
  r.cycle_days = 21
  r.total_cycles = 4
  r.evidence_level = 'A'
  r.page_reference = 'p.128'
end

# PE療法 - CDDP
cddp_sclc = RegimenDrug.find_or_create_by!(
  regimen: pe_sclc,
  drug: drugs['cisplatin']
) do |rd|
  rd.route = 'IV'
  rd.duration_min = 120
  rd.sequence_number = 1
end

cddp_sclc_schedule = RegimenDrugSchedule.find_or_create_by!(
  regimen_drug: cddp_sclc,
  start_day: 1,
  end_day: 1
)

ScheduleTiming.find_or_create_by!(
  regimen_drug_schedule: cddp_sclc_schedule,
  sequence: 1
) do |st|
  st.dose_per_time = 80
  st.dose_unit = 'mg/m2'
end

# PE療法 - ETP
etp_sclc = RegimenDrug.find_or_create_by!(
  regimen: pe_sclc,
  drug: drugs['etoposide']
) do |rd|
  rd.route = 'IV'
  rd.duration_min = 30
  rd.duration_max = 60
  rd.sequence_number = 2
end

etp_sclc_schedule = RegimenDrugSchedule.find_or_create_by!(
  regimen_drug: etp_sclc,
  start_day: 1,
  end_day: 3,
  interval_days: 1
)

ScheduleTiming.find_or_create_by!(
  regimen_drug_schedule: etp_sclc_schedule,
  sequence: 1
) do |st|
  st.dose_per_time = 100
  st.dose_unit = 'mg/m2'
end

# PE療法（精巣腫瘍）
pe_testicular = Regimen.find_or_create_by!(
  regimen_template: pe_template,
  cancer_type: cancer_types['精巣腫瘍'],
  reference_edition: edition_8,
  line_of_therapy: '1st'
) do |r|
  r.cycle_days = 21
  r.total_cycles = 4
  r.evidence_level = 'A'
  r.page_reference = 'p.245'
end

# PE療法（精巣腫瘍）- CDDP
cddp_testicular = RegimenDrug.find_or_create_by!(
  regimen: pe_testicular,
  drug: drugs['cisplatin']
) do |rd|
  rd.route = 'IV'
  rd.duration_min = 60
  rd.sequence_number = 1
end

cddp_testicular_schedule = RegimenDrugSchedule.find_or_create_by!(
  regimen_drug: cddp_testicular,
  start_day: 1,
  end_day: 5,
  interval_days: 1
)

ScheduleTiming.find_or_create_by!(
  regimen_drug_schedule: cddp_testicular_schedule,
  sequence: 1
) do |st|
  st.dose_per_time = 20
  st.dose_unit = 'mg/m2'
end

# PE療法（精巣腫瘍）- ETP
etp_testicular = RegimenDrug.find_or_create_by!(
  regimen: pe_testicular,
  drug: drugs['etoposide']
) do |rd|
  rd.route = 'IV'
  rd.duration_min = 30
  rd.duration_max = 60
  rd.sequence_number = 2
end

etp_testicular_schedule = RegimenDrugSchedule.find_or_create_by!(
  regimen_drug: etp_testicular,
  start_day: 1,
  end_day: 5,
  interval_days: 1
)

ScheduleTiming.find_or_create_by!(
  regimen_drug_schedule: etp_testicular_schedule,
  sequence: 1
) do |st|
  st.dose_per_time = 100
  st.dose_unit = 'mg/m2'
end

# S-1単独療法（胃がん）
s1_gastric = Regimen.find_or_create_by!(
  regimen_template: s1_template,
  cancer_type: cancer_types['胃がん'],
  reference_edition: edition_8,
  line_of_therapy: '1st'
) do |r|
  r.cycle_days = 42
  r.evidence_level = 'A'
  r.page_reference = 'p.89'
end

# S-1
s1_drug = RegimenDrug.find_or_create_by!(
  regimen: s1_gastric,
  drug: drugs['tegafur/gimeracil/oteracil']
) do |rd|
  rd.route = 'PO'
  rd.sequence_number = 1
end

s1_schedule = RegimenDrugSchedule.find_or_create_by!(
  regimen_drug: s1_drug,
  start_day: 1,
  end_day: 28,
  interval_days: 1
)

# 朝食後
ScheduleTiming.find_or_create_by!(
  regimen_drug_schedule: s1_schedule,
  sequence: 1
) do |st|
  st.timing_code = timing_codes['PCM']
  st.dose_per_time = 40
  st.dose_unit = 'mg/m2'
end

# 夕食後
ScheduleTiming.find_or_create_by!(
  regimen_drug_schedule: s1_schedule,
  sequence: 2
) do |st|
  st.timing_code = timing_codes['PCV']
  st.dose_per_time = 40
  st.dose_unit = 'mg/m2'
end

# ==========================================
# 追加薬剤
# ==========================================
puts '  Creating additional drugs...'

additional_drugs_data = [
  { generic_name: 'oxaliplatin', brand_name: 'エルプラット', abbreviation: 'L-OHP',
    codes: [{ system: 'YJ', code: '4291427A1027', display: 'オキサリプラチン点滴静注液100mg' }] },
  { generic_name: 'fluorouracil', brand_name: '5-FU', abbreviation: '5-FU',
    codes: [{ system: 'YJ', code: '4223402A1022', display: 'フルオロウラシル注250mg' }] },
  { generic_name: 'leucovorin', brand_name: 'ロイコボリン', abbreviation: 'LV',
    codes: [{ system: 'YJ', code: '3222001F1022', display: 'ロイコボリン錠25mg' }] },
  { generic_name: 'irinotecan', brand_name: 'カンプト', abbreviation: 'CPT-11',
    codes: [{ system: 'YJ', code: '4240404A1020', display: 'イリノテカン点滴静注液100mg' }] },
  { generic_name: 'doxorubicin', brand_name: 'アドリアシン', abbreviation: 'DXR',
    codes: [{ system: 'YJ', code: '4235400A1020', display: 'ドキソルビシン注射用10mg' }] },
  { generic_name: 'cyclophosphamide', brand_name: 'エンドキサン', abbreviation: 'CPA',
    codes: [{ system: 'YJ', code: '4211401A1020', display: 'シクロホスファミド注射用100mg' }] },
  { generic_name: 'docetaxel', brand_name: 'タキソテール', abbreviation: 'DTX',
    codes: [{ system: 'YJ', code: '4240405A1028', display: 'ドセタキセル点滴静注液80mg' }] },
  { generic_name: 'capecitabine', brand_name: 'ゼローダ', abbreviation: 'CAPE',
    codes: [{ system: 'YJ', code: '4229009F1020', display: 'カペシタビン錠300mg' }] },
  { generic_name: 'gemcitabine', brand_name: 'ジェムザール', abbreviation: 'GEM',
    codes: [{ system: 'YJ', code: '4224403A1020', display: 'ゲムシタビン点滴静注用200mg' }] },
  { generic_name: 'carboplatin', brand_name: 'パラプラチン', abbreviation: 'CBDCA',
    codes: [{ system: 'YJ', code: '4291403A1027', display: 'カルボプラチン点滴静注液150mg' }] },
  { generic_name: 'paclitaxel', brand_name: 'タキソール', abbreviation: 'PTX',
    codes: [{ system: 'YJ', code: '4240404A2024', display: 'パクリタキセル点滴静注液100mg' }] },
  { generic_name: 'vincristine', brand_name: 'オンコビン', abbreviation: 'VCR',
    codes: [{ system: 'YJ', code: '4240401A1020', display: 'ビンクリスチン注射用1mg' }] },
  { generic_name: 'prednisolone', brand_name: 'プレドニゾロン', abbreviation: 'PSL',
    codes: [{ system: 'YJ', code: '2456001F1020', display: 'プレドニゾロン錠5mg' }] },
  { generic_name: 'rituximab', brand_name: 'リツキサン', abbreviation: 'RTX',
    codes: [{ system: 'YJ', code: '4291428A1020', display: 'リツキシマブ点滴静注液100mg' }] },
  { generic_name: 'pembrolizumab', brand_name: 'キイトルーダ', abbreviation: 'PEMBRO',
    codes: [{ system: 'YJ', code: '4291451A1020', display: 'ペムブロリズマブ点滴静注100mg' }] }
]

additional_drugs_data.each do |data|
  drug = Drug.find_or_create_by!(generic_name: data[:generic_name]) do |d|
    d.brand_name = data[:brand_name]
    d.abbreviation = data[:abbreviation]
  end
  drugs[data[:generic_name]] = drug

  data[:codes].each do |code_data|
    DrugCode.find_or_create_by!(
      drug: drug,
      code_system_id: code_data[:system],
      code: code_data[:code]
    ) do |dc|
      dc.display = code_data[:display]
    end
  end
end

# ==========================================
# 追加がん腫
# ==========================================
puts '  Creating additional cancer types...'

additional_cancer_types = [
  { name: '大腸がん', codes: [{ system: 'ICD10', code: 'C18', display: '結腸の悪性新生物' }] },
  { name: '乳がん', codes: [{ system: 'ICD10', code: 'C50', display: '乳房の悪性新生物' }] },
  { name: '膀胱がん', codes: [{ system: 'ICD10', code: 'C67', display: '膀胱の悪性新生物' }] },
  { name: '卵巣がん', codes: [{ system: 'ICD10', code: 'C56', display: '卵巣の悪性新生物' }] },
  { name: '悪性リンパ腫', codes: [{ system: 'ICD10', code: 'C82', display: '濾胞性非ホジキンリンパ腫' }] },
  { name: '非小細胞肺がん', codes: [{ system: 'ICD10', code: 'C34', display: '気管支及び肺の悪性新生物' }] }
]

additional_cancer_types.each do |data|
  ct = CancerType.find_or_create_by!(name: data[:name])
  cancer_types[data[:name]] = ct
  data[:codes].each do |code_data|
    CancerTypeCode.find_or_create_by!(
      cancer_type: ct, code_system_id: code_data[:system], code: code_data[:code]
    ) { |ctc| ctc.display = code_data[:display] }
  end
end

# ==========================================
# 追加レジメンテンプレート
# ==========================================
puts '  Creating additional regimen templates...'

additional_templates = {
  'FOLFOX療法' => 'Oxaliplatin + Fluorouracil + Leucovorin',
  'FOLFIRI療法' => 'Irinotecan + Fluorouracil + Leucovorin',
  'AC療法' => 'Doxorubicin + Cyclophosphamide',
  'TC療法' => 'Docetaxel + Cyclophosphamide',
  'XELOX療法' => 'Capecitabine + Oxaliplatin',
  'GC療法' => 'Gemcitabine + Cisplatin',
  'カルボプラチン+パクリタキセル療法' => 'Carboplatin + Paclitaxel',
  'CHOP療法' => 'Cyclophosphamide + Doxorubicin + Vincristine + Prednisolone',
  'R-CHOP療法' => 'Rituximab + CHOP',
  'ペムブロリズマブ単独療法' => 'Pembrolizumab monotherapy'
}

templates = {}
additional_templates.each do |name, desc|
  templates[name] = RegimenTemplate.find_or_create_by!(name: name) { |rt| rt.description = desc }
end

# ==========================================
# 追加レジメン
# ==========================================
puts '  Creating additional regimens...'

folfox = Regimen.find_or_create_by!(
  regimen_template: templates['FOLFOX療法'],
  cancer_type: cancer_types['大腸がん'],
  reference_edition: edition_8,
  line_of_therapy: '1st'
) { |r| r.cycle_days = 14; r.total_cycles = 12; r.evidence_level = 'A'; r.page_reference = 'p.45' }

[
  { drug: drugs['oxaliplatin'],  route: 'IV', duration_min: 120,      seq: 1, start_day: 1, end_day: 1, dose: 85,   unit: 'mg/m2' },
  { drug: drugs['leucovorin'],   route: 'IV', duration_min: 120,      seq: 2, start_day: 1, end_day: 1, dose: 400,  unit: 'mg/m2' },
  { drug: drugs['fluorouracil'], route: 'IV', duration_min: 46 * 60,  seq: 3, start_day: 1, end_day: 2, dose: 2400, unit: 'mg/m2' }
].each do |d|
  rd = RegimenDrug.find_or_create_by!(regimen: folfox, drug: d[:drug]) do |r|
    r.route = d[:route]; r.duration_min = d[:duration_min]; r.sequence_number = d[:seq]
  end
  sched = RegimenDrugSchedule.find_or_create_by!(regimen_drug: rd, start_day: d[:start_day], end_day: d[:end_day])
  ScheduleTiming.find_or_create_by!(regimen_drug_schedule: sched, sequence: 1) do |st|
    st.dose_per_time = d[:dose]; st.dose_unit = d[:unit]
  end
end

folfiri = Regimen.find_or_create_by!(
  regimen_template: templates['FOLFIRI療法'],
  cancer_type: cancer_types['大腸がん'],
  reference_edition: edition_8,
  line_of_therapy: '2nd'
) { |r| r.cycle_days = 14; r.total_cycles = 12; r.evidence_level = 'A'; r.page_reference = 'p.48' }

[
  { drug: drugs['irinotecan'],   route: 'IV', duration_min: 90,     seq: 1, start_day: 1, end_day: 1, dose: 180,  unit: 'mg/m2' },
  { drug: drugs['leucovorin'],   route: 'IV', duration_min: 120,    seq: 2, start_day: 1, end_day: 1, dose: 400,  unit: 'mg/m2' },
  { drug: drugs['fluorouracil'], route: 'IV', duration_min: 46 * 60, seq: 3, start_day: 1, end_day: 2, dose: 2400, unit: 'mg/m2' }
].each do |d|
  rd = RegimenDrug.find_or_create_by!(regimen: folfiri, drug: d[:drug]) do |r|
    r.route = d[:route]
    r.duration_min = d[:duration_min]
    r.sequence_number = d[:seq]
  end
  sched = RegimenDrugSchedule.find_or_create_by!(regimen_drug: rd, start_day: d[:start_day], end_day: d[:end_day])
  ScheduleTiming.find_or_create_by!(regimen_drug_schedule: sched, sequence: 1) do |st|
    st.dose_per_time = d[:dose]
    st.dose_unit = d[:unit]
  end
end

ac = Regimen.find_or_create_by!(
  regimen_template: templates['AC療法'],
  cancer_type: cancer_types['乳がん'],
  reference_edition: edition_8,
  line_of_therapy: 'adjuvant'
) { |r| r.cycle_days = 21; r.total_cycles = 4; r.evidence_level = 'A'; r.page_reference = 'p.156' }

[
  { drug: drugs['doxorubicin'],      route: 'IV', duration_min: 15, seq: 1, start_day: 1, end_day: 1, dose: 60,  unit: 'mg/m2' },
  { drug: drugs['cyclophosphamide'], route: 'IV', duration_min: 30, seq: 2, start_day: 1, end_day: 1, dose: 600, unit: 'mg/m2' }
].each do |d|
  rd = RegimenDrug.find_or_create_by!(regimen: ac, drug: d[:drug]) do |r|
    r.route = d[:route]
    r.duration_min = d[:duration_min]
    r.sequence_number = d[:seq]
  end
  sched = RegimenDrugSchedule.find_or_create_by!(regimen_drug: rd, start_day: d[:start_day], end_day: d[:end_day])
  ScheduleTiming.find_or_create_by!(regimen_drug_schedule: sched, sequence: 1) do |st|
    st.dose_per_time = d[:dose]
    st.dose_unit = d[:unit]
  end
end

tc = Regimen.find_or_create_by!(
  regimen_template: templates['TC療法'],
  cancer_type: cancer_types['乳がん'],
  reference_edition: edition_8,
  line_of_therapy: 'adjuvant'
) { |r| r.cycle_days = 21; r.total_cycles = 4; r.evidence_level = 'A'; r.page_reference = 'p.158' }

[
  { drug: drugs['docetaxel'],        route: 'IV', duration_min: 60, seq: 1, start_day: 1, end_day: 1, dose: 75,  unit: 'mg/m2' },
  { drug: drugs['cyclophosphamide'], route: 'IV', duration_min: 30, seq: 2, start_day: 1, end_day: 1, dose: 600, unit: 'mg/m2' }
].each do |d|
  rd = RegimenDrug.find_or_create_by!(regimen: tc, drug: d[:drug]) do |r|
    r.route = d[:route]
    r.duration_min = d[:duration_min]
    r.sequence_number = d[:seq]
  end
  sched = RegimenDrugSchedule.find_or_create_by!(regimen_drug: rd, start_day: d[:start_day], end_day: d[:end_day])
  ScheduleTiming.find_or_create_by!(regimen_drug_schedule: sched, sequence: 1) do |st|
    st.dose_per_time = d[:dose]
    st.dose_unit = d[:unit]
  end
end

xelox = Regimen.find_or_create_by!(
  regimen_template: templates['XELOX療法'],
  cancer_type: cancer_types['胃がん'],
  reference_edition: edition_8,
  line_of_therapy: '1st'
) { |r| r.cycle_days = 21; r.total_cycles = 8; r.evidence_level = 'A'; r.page_reference = 'p.92' }

[
  { drug: drugs['oxaliplatin'],  route: 'IV', duration_min: 120, seq: 1, start_day: 1,  end_day: 1,  interval: nil, dose: 130,  unit: 'mg/m2' },
  { drug: drugs['capecitabine'], route: 'PO', duration_min: nil, seq: 2, start_day: 1,  end_day: 14, interval: 1,   dose: 1000, unit: 'mg/m2' }
].each do |d|
  rd = RegimenDrug.find_or_create_by!(regimen: xelox, drug: d[:drug]) do |r|
    r.route = d[:route]
    r.duration_min = d[:duration_min]
    r.sequence_number = d[:seq]
  end
  sched = RegimenDrugSchedule.find_or_create_by!(regimen_drug: rd, start_day: d[:start_day], end_day: d[:end_day]) do |s|
    s.interval_days = d[:interval]
  end
  ScheduleTiming.find_or_create_by!(regimen_drug_schedule: sched, sequence: 1) do |st|
    st.dose_per_time = d[:dose]
    st.dose_unit = d[:unit]
  end
end

gc = Regimen.find_or_create_by!(
  regimen_template: templates['GC療法'],
  cancer_type: cancer_types['膀胱がん'],
  reference_edition: edition_8,
  line_of_therapy: '1st'
) { |r| r.cycle_days = 21; r.total_cycles = 6; r.evidence_level = 'A'; r.page_reference = 'p.234' }

[
  { drug: drugs['gemcitabine'], route: 'IV', duration_min: 30,  seq: 1, start_day: 1, end_day: 8,  interval: 7, dose: 1000, unit: 'mg/m2' },
  { drug: drugs['cisplatin'],   route: 'IV', duration_min: 120, seq: 2, start_day: 2, end_day: 2,  interval: nil, dose: 70,  unit: 'mg/m2' }
].each do |d|
  rd = RegimenDrug.find_or_create_by!(regimen: gc, drug: d[:drug]) do |r|
    r.route = d[:route]
    r.duration_min = d[:duration_min]
    r.sequence_number = d[:seq]
  end
  sched = RegimenDrugSchedule.find_or_create_by!(regimen_drug: rd, start_day: d[:start_day], end_day: d[:end_day]) do |s|
    s.interval_days = d[:interval]
  end
  ScheduleTiming.find_or_create_by!(regimen_drug_schedule: sched, sequence: 1) do |st|
    st.dose_per_time = d[:dose]
    st.dose_unit = d[:unit]
  end
end

cbdca_ptx = Regimen.find_or_create_by!(
  regimen_template: templates['カルボプラチン+パクリタキセル療法'],
  cancer_type: cancer_types['卵巣がん'],
  reference_edition: edition_8,
  line_of_therapy: '1st'
) { |r| r.cycle_days = 21; r.total_cycles = 6; r.evidence_level = 'A'; r.page_reference = 'p.189' }

[
  { drug: drugs['paclitaxel'],  route: 'IV', duration_min: 180, seq: 1, start_day: 1, end_day: 1, interval: nil, dose: 175, unit: 'mg/m2' },
  { drug: drugs['carboplatin'], route: 'IV', duration_min: 60,  seq: 2, start_day: 1, end_day: 1, interval: nil, dose: 6,   unit: 'AUC' }
].each do |d|
  rd = RegimenDrug.find_or_create_by!(regimen: cbdca_ptx, drug: d[:drug]) do |r|
    r.route = d[:route]
    r.duration_min = d[:duration_min]
    r.sequence_number = d[:seq]
  end
  sched = RegimenDrugSchedule.find_or_create_by!(regimen_drug: rd, start_day: d[:start_day], end_day: d[:end_day]) do |s|
    s.interval_days = d[:interval]
  end
  ScheduleTiming.find_or_create_by!(regimen_drug_schedule: sched, sequence: 1) do |st|
    st.dose_per_time = d[:dose]
    st.dose_unit = d[:unit]
  end
end

chop = Regimen.find_or_create_by!(
  regimen_template: templates['CHOP療法'],
  cancer_type: cancer_types['悪性リンパ腫'],
  reference_edition: edition_8,
  line_of_therapy: '1st'
) { |r| r.cycle_days = 21; r.total_cycles = 6; r.evidence_level = 'A'; r.page_reference = 'p.278' }

[
  { drug: drugs['cyclophosphamide'], route: 'IV', duration_min: 30,  seq: 1, start_day: 1, end_day: 1, interval: nil, dose: 750, unit: 'mg/m2' },
  { drug: drugs['doxorubicin'],      route: 'IV', duration_min: 15,  seq: 2, start_day: 1, end_day: 1, interval: nil, dose: 50,  unit: 'mg/m2' },
  { drug: drugs['vincristine'],      route: 'IV', duration_min: 10,  seq: 3, start_day: 1, end_day: 1, interval: nil, dose: 1.4, unit: 'mg/m2' },
  { drug: drugs['prednisolone'],     route: 'PO', duration_min: nil, seq: 4, start_day: 1, end_day: 5, interval: 1,   dose: 100, unit: 'mg/body' }
].each do |d|
  rd = RegimenDrug.find_or_create_by!(regimen: chop, drug: d[:drug]) do |r|
    r.route = d[:route]
    r.duration_min = d[:duration_min]
    r.sequence_number = d[:seq]
  end
  sched = RegimenDrugSchedule.find_or_create_by!(regimen_drug: rd, start_day: d[:start_day], end_day: d[:end_day]) do |s|
    s.interval_days = d[:interval]
  end
  ScheduleTiming.find_or_create_by!(regimen_drug_schedule: sched, sequence: 1) do |st|
    st.dose_per_time = d[:dose]
    st.dose_unit = d[:unit]
  end
end

rchop = Regimen.find_or_create_by!(
  regimen_template: templates['R-CHOP療法'],
  cancer_type: cancer_types['悪性リンパ腫'],
  reference_edition: edition_8,
  line_of_therapy: '1st'
) { |r| r.cycle_days = 21; r.total_cycles = 6; r.evidence_level = 'A'; r.page_reference = 'p.280' }

[
  { drug: drugs['rituximab'],        route: 'IV', duration_min: 90,  seq: 1, start_day: 1, end_day: 1, interval: nil, dose: 375, unit: 'mg/m2' },
  { drug: drugs['cyclophosphamide'], route: 'IV', duration_min: 30,  seq: 2, start_day: 1, end_day: 1, interval: nil, dose: 750, unit: 'mg/m2' },
  { drug: drugs['doxorubicin'],      route: 'IV', duration_min: 15,  seq: 3, start_day: 1, end_day: 1, interval: nil, dose: 50,  unit: 'mg/m2' },
  { drug: drugs['vincristine'],      route: 'IV', duration_min: 10,  seq: 4, start_day: 1, end_day: 1, interval: nil, dose: 1.4, unit: 'mg/m2' },
  { drug: drugs['prednisolone'],     route: 'PO', duration_min: nil, seq: 5, start_day: 1, end_day: 5, interval: 1,   dose: 100, unit: 'mg/body' }
].each do |d|
  rd = RegimenDrug.find_or_create_by!(regimen: rchop, drug: d[:drug]) do |r|
    r.route = d[:route]
    r.duration_min = d[:duration_min]
    r.sequence_number = d[:seq]
  end
  sched = RegimenDrugSchedule.find_or_create_by!(regimen_drug: rd, start_day: d[:start_day], end_day: d[:end_day]) do |s|
    s.interval_days = d[:interval]
  end
  ScheduleTiming.find_or_create_by!(regimen_drug_schedule: sched, sequence: 1) do |st|
    st.dose_per_time = d[:dose]
    st.dose_unit = d[:unit]
  end
end

pembro = Regimen.find_or_create_by!(
  regimen_template: templates['ペムブロリズマブ単独療法'],
  cancer_type: cancer_types['非小細胞肺がん'],
  reference_edition: edition_8,
  line_of_therapy: '1st'
) { |r| r.cycle_days = 21; r.evidence_level = 'A'; r.page_reference = 'p.138' }

rd = RegimenDrug.find_or_create_by!(regimen: pembro, drug: drugs['pembrolizumab']) do |r|
  r.route = 'IV'
  r.duration_min = 30
  r.sequence_number = 1
end
sched = RegimenDrugSchedule.find_or_create_by!(regimen_drug: rd, start_day: 1, end_day: 1)
ScheduleTiming.find_or_create_by!(regimen_drug_schedule: sched, sequence: 1) do |st|
  st.dose_per_time = 200
  st.dose_unit = 'mg/body'
end

puts 'Seeding completed!'
puts ''
puts 'Summary:'
puts "  Code Systems: #{CodeSystem.count}"
puts "  Drugs: #{Drug.count}"
puts "  Drug Codes: #{DrugCode.count}"
puts "  Cancer Types: #{CancerType.count}"
puts "  Cancer Type Codes: #{CancerTypeCode.count}"
puts "  Reference Sources: #{ReferenceSource.count}"
puts "  Reference Editions: #{ReferenceEdition.count}"
puts "  Regimen Templates: #{RegimenTemplate.count}"
puts "  Timing Codes: #{TimingCode.count}"
puts "  Regimens: #{Regimen.count}"
puts "  Regimen Drugs: #{RegimenDrug.count}"
puts "  Regimen Drug Schedules: #{RegimenDrugSchedule.count}"
puts "  Schedule Timings: #{ScheduleTiming.count}"
