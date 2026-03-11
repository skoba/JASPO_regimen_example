# frozen_string_literal: true

class RegimenDrug < ApplicationRecord
  belongs_to :regimen
  belongs_to :drug

  has_many :regimen_drug_schedules, dependent: :destroy
  has_many :schedule_timings, through: :regimen_drug_schedules

  validates :route, presence: true, length: { maximum: 10 }
  validates :duration_min, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :duration_max, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validate :duration_range_valid

  ROUTES = {
    iv: 'IV',           # 静脈注射
    po: 'PO',           # 経口
    sc: 'SC',           # 皮下注射
    im: 'IM',           # 筋肉注射
    it: 'IT',           # 髄腔内
    ip: 'IP',           # 腹腔内
    topical: 'TOP'      # 外用
  }.freeze

  scope :ordered, -> { order(:sequence_number) }
  scope :iv_drugs, -> { where(route: 'IV') }
  scope :oral_drugs, -> { where(route: 'PO') }

  delegate :generic_name, :brand_name, to: :drug, prefix: true

  # 投与時間の範囲を文字列で取得
  def duration_range
    return nil if duration_min.nil? && duration_max.nil?
    return "#{duration_min}分" if duration_max.nil? || duration_min == duration_max
    return "#{duration_max}分以内" if duration_min.nil?
    "#{duration_min}〜#{duration_max}分"
  end

  # 全スケジュールの投与日リストを生成
  def administration_days
    regimen_drug_schedules.flat_map(&:administration_days).uniq.sort
  end

  private

  def duration_range_valid
    return if duration_min.nil? || duration_max.nil?
    
    if duration_min > duration_max
      errors.add(:duration_max, '下限より大きい値を指定してください')
    end
  end
end
