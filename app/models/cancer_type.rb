# frozen_string_literal: true

class CancerType < ApplicationRecord
  has_many :cancer_type_codes, dependent: :destroy
  has_many :code_systems, through: :cancer_type_codes
  has_many :regimens, dependent: :restrict_with_error
  has_many :regimen_templates, through: :regimens

  validates :name, presence: true, length: { maximum: 100 }

  scope :by_code, ->(system_id, code) {
    joins(:cancer_type_codes).where(cancer_type_codes: { code_system_id: system_id, code: code })
  }

  scope :by_icd10, ->(code) { by_code('ICD10', code) }

  # 特定のコード体系でのコードを取得
  def code_for(system_id)
    cancer_type_codes.find_by(code_system_id: system_id)&.code
  end

  # ICD-10コードを取得
  def icd10_code
    code_for('ICD10')
  end

  # FHIR CodeableConcept 形式で出力
  def to_fhir_codeable_concept
    {
      coding: cancer_type_codes.includes(:code_system).map do |ctc|
        {
          system: ctc.code_system.uri,
          code: ctc.code,
          display: ctc.display
        }
      end,
      text: name
    }
  end
end
