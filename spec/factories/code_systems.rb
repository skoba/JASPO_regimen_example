# frozen_string_literal: true

FactoryBot.define do
  factory :code_system do
    id { 'TEST' }
    name { 'Test Code System' }
    uri { 'http://example.com/code-system/test' }
    version { '1.0' }

    trait :yj do
      id { 'YJ' }
      name { '薬価基準収載医薬品コード' }
      uri { 'urn:oid:1.2.392.100495.20.2.71' }
      version { '2024' }
    end

    trait :hot do
      id { 'HOT' }
      name { 'HOTコード' }
      uri { 'urn:oid:1.2.392.100495.20.2.74' }
      version { '2024' }
    end

    trait :icd10 do
      id { 'ICD10' }
      name { 'ICD-10' }
      uri { 'http://hl7.org/fhir/sid/icd-10' }
      version { '2019' }
    end
  end
end
