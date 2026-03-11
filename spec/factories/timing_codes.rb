# frozen_string_literal: true

FactoryBot.define do
  factory :timing_code do
    sequence(:code) { |n| "T#{n}" }
    sequence(:display) { |n| "Timing #{n}" }
    fhir_when_code { code }
    sort_order { 1 }

    trait :morning do
      code { 'MORN' }
      display { '朝' }
      fhir_when_code { 'MORN' }
      sort_order { 1 }
    end

    trait :evening do
      code { 'EVE' }
      display { '夕' }
      fhir_when_code { 'EVE' }
      sort_order { 3 }
    end

    trait :after_breakfast do
      code { 'PCM' }
      display { '朝食後' }
      fhir_when_code { 'PCM' }
      sort_order { 21 }
    end

    trait :after_dinner do
      code { 'PCV' }
      display { '夕食後' }
      fhir_when_code { 'PCV' }
      sort_order { 25 }
    end
  end
end
