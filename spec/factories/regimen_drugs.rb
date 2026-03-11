# frozen_string_literal: true

FactoryBot.define do
  factory :regimen_drug do
    association :regimen
    association :drug
    route { 'IV' }
    duration_min { 60 }
    duration_max { nil }
    sequence(:sequence_number) { |n| n }

    trait :intravenous do
      route { 'IV' }
      duration_min { 60 }
      duration_max { 120 }
    end

    trait :oral do
      route { 'PO' }
      duration_min { nil }
      duration_max { nil }
    end

    trait :with_schedule do
      after(:create) do |regimen_drug|
        create(:regimen_drug_schedule, regimen_drug: regimen_drug)
      end
    end
  end
end
