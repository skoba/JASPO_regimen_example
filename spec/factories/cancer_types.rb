# frozen_string_literal: true

FactoryBot.define do
  factory :cancer_type do
    sequence(:name) { |n| "Cancer Type #{n}" }

    trait :lung_cancer do
      name { '肺がん' }
    end

    trait :small_cell_lung_cancer do
      name { '小細胞肺がん' }
    end

    trait :gastric_cancer do
      name { '胃がん' }
    end

    trait :with_codes do
      after(:create) do |cancer_type|
        create(:cancer_type_code, :icd10, cancer_type: cancer_type)
      end
    end
  end
end
