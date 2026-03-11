# frozen_string_literal: true

FactoryBot.define do
  factory :regimen_drug_schedule do
    association :regimen_drug
    start_day { 1 }
    end_day { 1 }
    interval_days { 1 }

    trait :single_day do
      start_day { 1 }
      end_day { 1 }
      interval_days { 1 }
    end

    trait :three_day_course do
      start_day { 1 }
      end_day { 3 }
      interval_days { 1 }
    end

    trait :five_day_course do
      start_day { 1 }
      end_day { 5 }
      interval_days { 1 }
    end

    trait :with_timings do
      after(:create) do |schedule|
        create(:schedule_timing, regimen_drug_schedule: schedule, sequence: 1)
      end
    end
  end
end
