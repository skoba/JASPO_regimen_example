# frozen_string_literal: true

class CodeSystem < ApplicationRecord
  self.primary_key = :id

  has_many :drug_codes, foreign_key: :code_system_id, dependent: :restrict_with_error
  has_many :cancer_type_codes, foreign_key: :code_system_id, dependent: :restrict_with_error

  validates :id, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :name, presence: true, length: { maximum: 100 }
  validates :uri, presence: true, length: { maximum: 255 }
  validates :version, length: { maximum: 20 }, allow_nil: true

  # 主要なコード体系
  SYSTEMS = {
    yj: 'YJ',
    hot: 'HOT',
    atc: 'ATC',
    icd10: 'ICD10',
    icd_o3: 'ICDO3',
    medis: 'MEDIS'
  }.freeze

  scope :for_drugs, -> { where(id: %w[YJ HOT ATC]) }
  scope :for_cancer_types, -> { where(id: %w[ICD10 ICDO3 MEDIS]) }
end
