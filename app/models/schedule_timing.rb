# frozen_string_literal: true

class ScheduleTiming < ApplicationRecord
  belongs_to :regimen_drug_schedule
  belongs_to :timing_code, optional: true

  validates :dose_per_time, presence: true, numericality: { greater_than: 0 }
  validates :dose_unit, presence: true, length: { maximum: 20 }
  validates :sequence, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :sequence, uniqueness: { scope: :regimen_drug_schedule_id }

  DOSE_UNITS = {
    mg_per_m2: 'mg/m2',
    mg_per_kg: 'mg/kg',
    mg_per_body: 'mg/body',
    mg: 'mg',
    g: 'g',
    mcg: 'mcg',
    units: 'units',
    auc: 'AUC'
  }.freeze

  scope :ordered, -> { order(:sequence) }

  delegate :display, to: :timing_code, prefix: true, allow_nil: true

  # タイミング表示（朝食後、など）
  def timing_display
    timing_code&.display || '（指定なし）'
  end

  # 用量表示（例: "40 mg/m2"）
  def dose_display
    "#{dose_per_time} #{dose_unit}"
  end

  # 完全な表示（例: "朝食後 40 mg/m2"）
  def full_display
    if timing_code.present?
      "#{timing_display} #{dose_display}"
    else
      dose_display
    end
  end

  # FHIR Dosage 形式で出力
  def to_fhir_dosage
    dosage = {
      doseAndRate: [{
        doseQuantity: {
          value: dose_per_time,
          unit: dose_unit
        }
      }]
    }

    if timing_code.present?
      dosage[:timing] = {
        repeat: {
          when: [timing_code.to_fhir_when]
        }
      }
    end

    dosage
  end
end
