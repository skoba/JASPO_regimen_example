# frozen_string_literal: true

FactoryBot.define do
  factory :reference_source do
    sequence(:name) { |n| "Reference Source #{n}" }
    source_type { 'book' }
    publisher { 'Test Publisher' }
    isbn { '978-4-7581-0000-0' }
    url { nil }

    trait :handbook do
      name { 'がん化学療法レジメンハンドブック' }
      source_type { 'book' }
      publisher { '羊土社' }
      isbn { '978-4-7581-1234-5' }
    end

    trait :guideline do
      source_type { 'guideline' }
      publisher { nil }
      isbn { nil }
      url { 'http://example.com/guideline' }
    end
  end
end
