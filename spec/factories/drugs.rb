# frozen_string_literal: true

FactoryBot.define do
  factory :drug do
    sequence(:generic_name) { |n| "Generic Drug #{n}" }
    sequence(:brand_name) { |n| "Brand Name #{n}" }

    trait :cisplatin do
      generic_name { 'cisplatin' }
      brand_name { 'ランダ' }
    end

    trait :etoposide do
      generic_name { 'etoposide' }
      brand_name { 'ベプシド' }
    end

    trait :with_codes do
      after(:create) do |drug|
        create(:drug_code, :yj, drug: drug)
        create(:drug_code, :hot, drug: drug)
      end
    end
  end
end
