# frozen_string_literal: true

FactoryBot.define do
  factory :drug_code do
    association :drug
    code_system_id { 'YJ' }
    sequence(:code) { |n| "400000#{n}" }
    display { 'Test Drug Code Display' }

    before(:create) do |drug_code|
      unless CodeSystem.exists?(drug_code.code_system_id)
        create(:code_system, id: drug_code.code_system_id)
      end
    end

    trait :yj do
      code_system_id { 'YJ' }
      code { '4291401A1027' }
      display { 'シスプラチン注50mg' }
    end

    trait :hot do
      code_system_id { 'HOT' }
      code { '1078453010101' }
      display { 'シスプラチン点滴静注液50mg' }
    end
  end
end
