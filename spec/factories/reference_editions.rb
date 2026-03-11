# frozen_string_literal: true

FactoryBot.define do
  factory :reference_edition do
    association :reference_source
    sequence(:edition_number) { |n| "第#{n}版" }
    publication_date { Date.new(2023, 3, 1) }
    effective_date { Date.new(2023, 4, 1) }
    notes { nil }

    trait :edition_8 do
      edition_number { '第8版' }
      publication_date { Date.new(2023, 3, 1) }
      effective_date { Date.new(2023, 4, 1) }
    end

    trait :edition_7 do
      edition_number { '第7版' }
      publication_date { Date.new(2020, 3, 1) }
      effective_date { Date.new(2020, 4, 1) }
    end
  end
end
