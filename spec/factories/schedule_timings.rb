# frozen_string_literal: true

FactoryBot.define do
  factory :schedule_timing do
    association :regimen_drug_schedule
    timing_code { nil }
    dose_per_time { 100.0 }
    dose_unit { 'mg/m2' }
    sequence(:sequence) { |n| n }

    trait :standard_dose do
      dose_per_time { 80.0 }
      dose_unit { 'mg/m2' }
    end

    trait :body_weight_based do
      dose_per_time { 5.0 }
      dose_unit { 'mg/kg' }
    end

    trait :fixed_dose do
      dose_per_time { 100.0 }
      dose_unit { 'mg/body' }
    end

    trait :oral_dose do
      dose_per_time { 40.0 }
      dose_unit { 'mg/m2' }
    end
  end
end
