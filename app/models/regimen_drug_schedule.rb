# frozen_string_literal: true

class RegimenDrugSchedule < ApplicationRecord
  belongs_to :regimen_drug

  has_many :schedule_timings, dependent: :destroy

  validates :start_day, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :end_day, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :interval_days, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validate :end_day_not_before_start_day

  delegate :drug, :route, to: :regimen_drug

  # 投与日リストを生成
  def administration_days
    return [start_day] if start_day == end_day
    
    interval = interval_days || 1
    days = []
    current_day = start_day
    
    while current_day <= end_day
      days << current_day
      current_day += interval
    end
    
    days
  end

  # 投与日数
  def total_days
    administration_days.length
  end

  # スケジュール文字列（例: "Day 1-3", "Day 1, 8, 15"）
  def schedule_text
    days = administration_days
    
    if days.length == 1
      "Day #{days.first}"
    elsif interval_days == 1 || interval_days.nil?
      "Day #{start_day}-#{end_day}"
    else
      "Day #{days.join(', ')}"
    end
  end

  # 1日の総投与量
  def daily_total_dose
    schedule_timings.sum(:dose_per_time)
  end

  # 1日の投与回数
  def times_per_day
    schedule_timings.count
  end

  private

  def end_day_not_before_start_day
    return if start_day.nil? || end_day.nil?
    
    if end_day < start_day
      errors.add(:end_day, '開始日以降の日付を指定してください')
    end
  end
end
