# frozen_string_literal: true

class TimingCode < ApplicationRecord
  has_many :schedule_timings, dependent: :restrict_with_error

  validates :code, presence: true, length: { maximum: 20 }, uniqueness: true
  validates :display, presence: true, length: { maximum: 50 }
  validates :fhir_when_code, length: { maximum: 20 }, allow_nil: true

  scope :ordered, -> { order(:sort_order) }

  # FHIR Timing.repeat.when コードを取得
  def to_fhir_when
    fhir_when_code || code
  end

  # 主要なタイミングコード
  CODES = {
    morning: 'MORN',
    afternoon: 'AFT',
    evening: 'EVE',
    night: 'NIGHT',
    before_meal: 'AC',
    after_meal: 'PC',
    before_breakfast: 'ACM',
    after_breakfast: 'PCM',
    before_lunch: 'ACD',
    after_lunch: 'PCD',
    before_dinner: 'ACV',
    after_dinner: 'PCV'
  }.freeze
end
