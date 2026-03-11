# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Drug, type: :model do
  describe 'associations' do
    it { should have_many(:drug_codes).dependent(:destroy) }
    it { should have_many(:code_systems).through(:drug_codes) }
    it { should have_many(:regimen_drugs).dependent(:restrict_with_error) }
    it { should have_many(:regimens).through(:regimen_drugs) }
  end

  describe 'validations' do
    it { should validate_presence_of(:generic_name) }
    it { should validate_length_of(:generic_name).is_at_most(200) }
    it { should validate_length_of(:brand_name).is_at_most(200) }
  end

  describe 'scopes' do
    describe '.by_code' do
      let!(:code_system) { create(:code_system, :yj) }
      let!(:drug) { create(:drug, :cisplatin) }
      let!(:drug_code) { create(:drug_code, drug: drug, code_system_id: 'YJ', code: '12345') }

      it 'finds drugs by code system and code' do
        result = Drug.by_code('YJ', '12345')
        expect(result).to include(drug)
      end
    end
  end

  describe 'code methods' do
    let(:code_system_yj) { create(:code_system, :yj) }
    let(:code_system_hot) { create(:code_system, :hot) }
    let(:drug) { create(:drug, :cisplatin) }

    before do
      create(:drug_code, drug: drug, code_system_id: 'YJ', code: 'YJ123')
      create(:drug_code, drug: drug, code_system_id: 'HOT', code: 'HOT456')
    end

    describe '#code_for' do
      it 'returns code for specified system' do
        expect(drug.code_for('YJ')).to eq('YJ123')
        expect(drug.code_for('HOT')).to eq('HOT456')
      end

      it 'returns nil for non-existent code system' do
        expect(drug.code_for('UNKNOWN')).to be_nil
      end
    end

    describe '#yj_code' do
      it 'returns YJ code' do
        expect(drug.yj_code).to eq('YJ123')
      end
    end

    describe '#hot_code' do
      it 'returns HOT code' do
        expect(drug.hot_code).to eq('HOT456')
      end
    end
  end

  describe '#to_fhir_codeable_concept' do
    let(:code_system_yj) { create(:code_system, :yj) }
    let(:drug) { create(:drug, generic_name: 'Test Drug') }
    let!(:drug_code) do
      create(:drug_code,
             drug: drug,
             code_system_id: 'YJ',
             code: 'TEST123',
             display: 'Test Display')
    end

    it 'returns FHIR CodeableConcept format' do
      result = drug.to_fhir_codeable_concept
      expect(result).to be_a(Hash)
      expect(result[:text]).to eq('Test Drug')
      expect(result[:coding]).to be_an(Array)
      expect(result[:coding].first[:code]).to eq('TEST123')
      expect(result[:coding].first[:display]).to eq('Test Display')
    end
  end
end
