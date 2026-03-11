# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CodeSystem, type: :model do
  describe 'associations' do
    it { should have_many(:drug_codes).dependent(:restrict_with_error) }
    it { should have_many(:cancer_type_codes).dependent(:restrict_with_error) }
  end

  describe 'validations' do
    subject { build(:code_system) }

    it { should validate_presence_of(:id) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:uri) }
    it { should validate_length_of(:id).is_at_most(20) }
    it { should validate_length_of(:name).is_at_most(100) }
    it { should validate_length_of(:uri).is_at_most(255) }
    it { should validate_length_of(:version).is_at_most(20) }
  end

  describe 'scopes' do
    before do
      create(:code_system, :yj)
      create(:code_system, :hot)
      create(:code_system, :icd10)
    end

    describe '.for_drugs' do
      it 'returns code systems for drugs' do
        result = CodeSystem.for_drugs
        expect(result.map(&:id)).to contain_exactly('YJ', 'HOT')
      end
    end

    describe '.for_cancer_types' do
      it 'returns code systems for cancer types' do
        result = CodeSystem.for_cancer_types
        expect(result.map(&:id)).to include('ICD10')
      end
    end
  end

  describe 'string primary key' do
    it 'uses string as primary key' do
      code_system = create(:code_system, id: 'TEST123')
      expect(code_system.id).to eq('TEST123')
      expect(CodeSystem.find('TEST123')).to eq(code_system)
    end
  end
end
