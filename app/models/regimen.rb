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
