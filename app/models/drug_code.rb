# frozen_string_literal: true

class DrugCode < ApplicationRecord
  belongs_to :drug
  belongs_to :code_system, foreign_key: :code_system_id

  validates :code, presence: true, length: { maximum: 50 }
  validates :display, length: { maximum: 200 }, allow_nil: true
  validates :code, uniqueness: { scope: [:drug_id, :code_system_id] }

  scope :by_system, ->(system_id) { where(code_system_id: system_id) }
  scope :yj_codes, -> { by_system('YJ') }
  scope :hot_codes, -> { by_system('HOT') }
  scope :atc_codes, -> { by_system('ATC') }
end
