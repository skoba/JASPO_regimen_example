# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CancerType, type: :model do
  describe 'associations' do
    it { should have_many(:cancer_type_codes).dependent(:destroy) }
    it { should have_many(:code_systems).through(:cancer_type_codes) }
    it { should have_many(:regimens).dependent(:restrict_with_error) }
    it { should have_many(:regimen_templates).through(:regimens) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(100) }
  end

  describe 'scopes' do
    describe '.by_code' do
      let!(:code_system) { create(:code_system, :icd10) }
      let!(:cancer_type) { create(:cancer_type, :lung_cancer) }
      let!(:cancer_type_code) do
        create(:cancer_type_code, cancer_type: cancer_type, code_system_id: 'ICD10', code: 'C34')
      end

      it 'finds cancer types by code system and code' do
        result = CancerType.by_code('ICD10', 'C34')
        expect(result).to include(cancer_type)
      end
    end

    describe '.by_icd10' do
      let!(:code_system) { create(:code_system, :icd10) }
      let!(:cancer_type) { create(:cancer_type, :lung_cancer) }
      let!(:cancer_type_code) do
        create(:cancer_type_code, cancer_type: cancer_type, code_system_id: 'ICD10', code: 'C34')
      end

      it 'finds cancer types by ICD-10 code' do
        result = CancerType.by_icd10('C34')
        expect(result).to include(cancer_type)
      end
    end
  end

  describe '#code_for' do
    let(:code_system_icd10) { create(:code_system, :icd10) }
    let(:cancer_type) { create(:cancer_type, :lung_cancer) }

    before do
      create(:cancer_type_code, cancer_type: cancer_type, code_system_id: 'ICD10', code: 'C34')
    end

    it 'returns code for specified system' do
      expect(cancer_type.code_for('ICD10')).to eq('C34')
    end

    it 'returns nil for non-existent code system' do
      expect(cancer_type.code_for('UNKNOWN')).to be_nil
    end
  end

  describe '#icd10_code' do
    let(:code_system_icd10) { create(:code_system, :icd10) }
    let(:cancer_type) { create(:cancer_type, :lung_cancer) }

    before do
      create(:cancer_type_code, cancer_type: cancer_type, code_system_id: 'ICD10', code: 'C34')
    end

    it 'returns ICD-10 code' do
      expect(cancer_type.icd10_code).to eq('C34')
    end
  end

  describe '#to_fhir_codeable_concept' do
    let(:code_system_icd10) { create(:code_system, :icd10) }
    let(:cancer_type) { create(:cancer_type, name: 'Test Cancer') }
    let!(:cancer_type_code) do
      create(:cancer_type_code,
             cancer_type: cancer_type,
             code_system_id: 'ICD10',
             code: 'C00',
             display: 'Test Cancer Display')
    end

    it 'returns FHIR CodeableConcept format' do
      result = cancer_type.to_fhir_codeable_concept
      expect(result).to be_a(Hash)
      expect(result[:text]).to eq('Test Cancer')
      expect(result[:coding]).to be_an(Array)
      expect(result[:coding].first[:code]).to eq('C00')
      expect(result[:coding].first[:display]).to eq('Test Cancer Display')
    end
  end
end
