# frozen_string_literal: true

class ReferenceEdition < ApplicationRecord
  belongs_to :reference_source
  has_many :regimens, dependent: :restrict_with_error

  validates :edition_number, presence: true, length: { maximum: 20 }
  validates :edition_number, uniqueness: { scope: :reference_source_id }

  scope :latest_first, -> { order(publication_date: :desc) }
  scope :effective_on, ->(date) { where('effective_date <= ?', date).latest_first }

  delegate :name, :source_type, :publisher, to: :reference_source, prefix: :source

  # 現在有効な版かどうか
  def currently_effective?
    effective_date.present? && effective_date <= Date.current
  end

  # 完全な名称（出典名 + 版番号）
  def full_name
    "#{reference_source.name} #{edition_number}"
  end
end
