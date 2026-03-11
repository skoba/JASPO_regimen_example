# frozen_string_literal: true

FactoryBot.define do
  factory :regimen_template do
    sequence(:name) { |n| "Regimen Template #{n}" }
    description { 'Test regimen description' }

    trait :pe_therapy do
      name { 'PE療法' }
      description { 'Cisplatin + Etoposide' }
    end

    trait :s1_monotherapy do
      name { 'S-1単独療法' }
      description { 'Tegafur/Gimeracil/Oteracil 単剤' }
    end
  end
end
