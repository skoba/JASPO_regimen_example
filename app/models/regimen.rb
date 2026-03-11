# frozen_string_literal: true

class Regimen < ApplicationRecord
  self.table_name = 'regimens'

  belongs_to :regimen_template
  belongs_to :cancer_type
  belongs_to :reference_edition

  has_many :regimen_drugs, dependent: :destroy
  has_many :drugs, through: :regimen_drugs

  validates :line_of_therapy, length: { maximum: 20 }, allow_nil: true
  validates :evidence_level, length: { maximum: 10 }, allow_nil: true
  validates :page_reference, length: { maximum: 50 }, allow_nil: true
  validates :cycle_days, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :total_cycles, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  validate :unique_regimen_combination

  delegate :name, to: :regimen_template, prefix: :template
  delegate :name, to: :cancer_type, prefix: :cancer_type
  delegate :edition_number, :full_name, to: :reference_edition, prefix: :edition

  scope :by_template, ->(template_name) {
    joins(:regimen_template).where(regimen_templates: { name: template_name })
  }

  scope :by_cancer_type, ->(cancer_type_name) {
    joins(:cancer_type).where(cancer_types: { name: cancer_type_name })
  }

  scope :by_icd10, ->(code) {
    joins(cancer_type: :cancer_type_codes)
      .where(cancer_type_codes: { code_system_id: 'ICD10', code: code })
  }

  scope :first_line, -> { where(line_of_therapy: '1st') }
  scope :second_line, -> { where(line_of_therapy: '2nd') }
  scope :adjuvant, -> { where(line_of_therapy: 'adjuvant') }

  scope :from_latest_edition, ->(source_id) {
    joins(:reference_edition)
      .where(reference_editions: { reference_source_id: source_id })
      .order('reference_editions.publication_date DESC')
  }

  # 完全な名称
  def full_name
    parts = [template_name, cancer_type_name]
    parts << line_of_therapy if line_of_therapy.present?
    parts.join(' / ')
  end

  # 薬剤を投与順序でソート
  def ordered_drugs
    regimen_drugs.includes(:drug).order(:sequence_number)
  end

  # FHIR PlanDefinition 形式で出力
  def to_fhir
    resource = {
      resourceType: 'PlanDefinition',
      id: id.to_s,
      status: 'active',
      title: full_name,
      type: {
        coding: [{
          system: 'http://terminology.hl7.org/CodeSystem/plan-definition-type',
          code: 'clinical-protocol',
          display: 'Clinical Protocol'
        }]
      },
      useContext: [{
        code: {
          system: 'http://terminology.hl7.org/CodeSystem/usage-context-type',
          code: 'focus'
        },
        valueCodeableConcept: cancer_type.to_fhir_codeable_concept
      }],
      extension: fhir_cycle_extensions,
      action: regimen_drugs.order(:sequence_number).map { |rd| fhir_action_for(rd) }
    }
    resource.delete(:extension) if resource[:extension].empty?
    resource
  end

  # レジメン詳細のサマリー
  def summary
    ordered_drugs.map do |rd|
      drug_name = rd.drug.generic_name
      schedules = rd.regimen_drug_schedules.map do |rds|
        timing_info = rds.schedule_timings.map do |st|
          "#{st.dose_per_time}#{st.dose_unit}"
        end.join(', ')
        
        day_info = rds.start_day == rds.end_day ? "Day #{rds.start_day}" : "Day #{rds.start_day}-#{rds.end_day}"
        "#{day_info}: #{timing_info}"
      end.join('; ')
      
      "#{drug_name} (#{rd.route}) - #{schedules}"
    end
  end

  private

  ROUTE_CODINGS = {
    'IV'  => { system: 'http://snomed.info/sct', code: '47625008', display: 'Intravenous route' },
    'PO'  => { system: 'http://snomed.info/sct', code: '26643006', display: 'Oral route' },
    'SC'  => { system: 'http://snomed.info/sct', code: '34206005', display: 'Subcutaneous route' },
    'IM'  => { system: 'http://snomed.info/sct', code: '78421000', display: 'Intramuscular route' }
  }.freeze

  def fhir_cycle_extensions
    extensions = []
    if cycle_days
      extensions << {
        url: 'http://example.com/fhir/StructureDefinition/cycle-days',
        valueInteger: cycle_days
      }
    end
    if total_cycles
      extensions << {
        url: 'http://example.com/fhir/StructureDefinition/total-cycles',
        valueInteger: total_cycles
      }
    end
    extensions
  end

  def fhir_action_for(regimen_drug)
    drug = regimen_drug.drug
    action = {
      title: [drug.generic_name, drug.abbreviation].compact.join(' / '),
      code: [drug.to_fhir_codeable_concept]
    }

    route_coding = ROUTE_CODINGS[regimen_drug.route]
    action[:action] = regimen_drug.regimen_drug_schedules.map do |schedule|
      dosage = {
        timing: {
          repeat: {
            boundsDuration: cycle_days ? { value: cycle_days, unit: 'd', system: 'http://unitsofmeasure.org', code: 'd' } : nil,
            offset: schedule.start_day == schedule.end_day ? (schedule.start_day - 1) * 24 * 60 : nil
          }.compact
        }
      }

      unless schedule.start_day == schedule.end_day
        dosage[:timing][:repeat][:count] = schedule.schedule_timings.count * schedule.administration_days.length
      end

      dosage[:route] = { coding: [route_coding] } if route_coding
      dosage[:doseAndRate] = schedule.schedule_timings.order(:sequence).map do |st|
        rate = { doseQuantity: { value: st.dose_per_time, unit: st.dose_unit } }
        if st.timing_code
          dosage[:timing][:repeat][:when] = [st.timing_code.to_fhir_when]
        end
        rate
      end

      {
        title: "Day #{schedule.start_day}#{schedule.start_day == schedule.end_day ? '' : "-#{schedule.end_day}"}",
        dosage: [dosage]
      }
    end

    action
  end

  def unique_regimen_combination
    existing = Regimen.where(
      regimen_template_id: regimen_template_id,
      cancer_type_id: cancer_type_id,
      reference_edition_id: reference_edition_id,
      line_of_therapy: line_of_therapy
    ).where.not(id: id)

    if existing.exists?
      errors.add(:base, 'この組み合わせのレジメンは既に存在します')
    end
  end
end
