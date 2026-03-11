# frozen_string_literal: true

class RegimenTemplate < ApplicationRecord
  has_many :regimens, dependent: :restrict_with_error
  has_many :cancer_types, -> { distinct }, through: :regimens
  has_many :reference_editions, -> { distinct }, through: :regimens

  validates :name, presence: true, length: { maximum: 100 }, uniqueness: true

  scope :by_name, ->(name) { where('name LIKE ?', "%#{name}%") }

  # このテンプレートで使われている全ての薬剤
  def drugs
    Drug.joins(regimen_drugs: :regimen)
        .where(regimens: { regimen_template_id: id })
        .distinct
  end

  # 対象となるがん腫一覧
  def target_cancer_types
    cancer_types.distinct
  end
end
