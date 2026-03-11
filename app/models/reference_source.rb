# frozen_string_literal: true

class ReferenceSource < ApplicationRecord
  has_many :reference_editions, dependent: :restrict_with_error
  has_many :regimens, through: :reference_editions

  validates :name, presence: true, length: { maximum: 200 }
  validates :source_type, presence: true, inclusion: { in: %w[book guideline protocol] }
  validates :publisher, length: { maximum: 100 }, allow_nil: true
  validates :isbn, length: { maximum: 20 }, allow_nil: true
  validates :url, length: { maximum: 255 }, allow_nil: true

  SOURCE_TYPES = {
    book: 'book',
    guideline: 'guideline',
    protocol: 'protocol'
  }.freeze

  scope :books, -> { where(source_type: 'book') }
  scope :guidelines, -> { where(source_type: 'guideline') }
  scope :protocols, -> { where(source_type: 'protocol') }

  # 最新版を取得
  def latest_edition
    reference_editions.order(publication_date: :desc).first
  end
end
