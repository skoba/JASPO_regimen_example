# frozen_string_literal: true

class CancerTypeCode < ApplicationRecord
  belongs_to :cancer_type
  belongs_to :code_system, foreign_key: :code_system_id

  validates :code, presence: true, length: { maximum: 50 }
  validates :display, length: { maximum: 200 }, allow_nil: true
  validates :code, uniqueness: { scope: [:cancer_type_id, :code_system_id] }

  scope :by_system, ->(system_id) { where(code_system_id: system_id) }
  scope :icd10_codes, -> { by_system('ICD10') }
  scope :icd_o3_codes, -> { by_system('ICDO3') }
end
