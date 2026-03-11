# frozen_string_literal: true

FactoryBot.define do
  factory :cancer_type_code do
    association :cancer_type
    code_system_id { 'ICD10' }
    sequence(:code) { |n| "C#{n.to_s.rjust(2, '0')}" }
    display { 'Test Cancer Type Code' }

    before(:create) do |cancer_type_code|
      unless CodeSystem.exists?(cancer_type_code.code_system_id)
        create(:code_system, id: cancer_type_code.code_system_id)
      end
    end

    trait :icd10 do
      code_system_id { 'ICD10' }
      code { 'C34' }
      display { '気管支及び肺の悪性新生物' }
    end

    trait :icdo3 do
      code_system_id { 'ICDO3' }
      code { '8041/3' }
      display { 'Small cell carcinoma, NOS' }
    end
  end
end
