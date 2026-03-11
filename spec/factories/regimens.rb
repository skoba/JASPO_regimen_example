# frozen_string_literal: true

FactoryBot.define do
  factory :regimen do
    association :regimen_template
    association :cancer_type
    association :reference_edition
    line_of_therapy { '1st' }
    cycle_days { 21 }
    total_cycles { 4 }
    evidence_level { 'A' }
    page_reference { 'p.100' }

    trait :first_line do
      line_of_therapy { '1st' }
    end

    trait :second_line do
      line_of_therapy { '2nd' }
    end

    trait :adjuvant do
      line_of_therapy { 'adjuvant' }
    end

    trait :with_drugs do
      after(:create) do |regimen|
        drug1 = create(:drug, :cisplatin)
        drug2 = create(:drug, :etoposide)
        create(:regimen_drug, regimen: regimen, drug: drug1, sequence_number: 1)
        create(:regimen_drug, regimen: regimen, drug: drug2, sequence_number: 2)
      end
    end
  end
end
