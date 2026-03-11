# frozen_string_literal: true

class Drug < ApplicationRecord
  has_many :drug_codes, dependent: :destroy
  has_many :code_systems, through: :drug_codes
  has_many :regimen_drugs, dependent: :restrict_with_error
  has_many :regimens, through: :regimen_drugs

  validates :generic_name, presence: true, length: { maximum: 200 }
  validates :brand_name, length: { maximum: 200 }, allow_nil: true
  validates :abbreviation, length: { maximum: 20 }, allow_nil: true

  scope :by_code, ->(system_id, code) {
    joins(:drug_codes).where(drug_codes: { code_system_id: system_id, code: code })
  }

  # 特定のコード体系でのコードを取得
  def code_for(system_id)
    drug_codes.find_by(code_system_id: system_id)&.code
  end

  # YJコードを取得
  def yj_code
    code_for('YJ')
  end

  # HOTコードを取得
  def hot_code
    code_for('HOT')
  end

  # FHIR CodeableConcept 形式で出力
  def to_fhir_codeable_concept
    {
      coding: drug_codes.includes(:code_system).map do |dc|
        {
          system: dc.code_system.uri,
          code: dc.code,
          display: dc.display
        }
      end,
      text: generic_name
    }
  end
end
