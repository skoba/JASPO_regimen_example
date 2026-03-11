# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Regimen, type: :model do
  describe 'associations' do
    it { should belong_to(:regimen_template) }
    it { should belong_to(:cancer_type) }
    it { should belong_to(:reference_edition) }
    it { should have_many(:regimen_drugs).dependent(:destroy) }
    it { should have_many(:drugs).through(:regimen_drugs) }
  end

  describe 'validations' do
    it { should validate_length_of(:line_of_therapy).is_at_most(20) }
    it { should validate_length_of(:evidence_level).is_at_most(10) }
    it { should validate_length_of(:page_reference).is_at_most(50) }

    it 'validates cycle_days is greater than 0' do
      regimen = build(:regimen, cycle_days: 0)
      expect(regimen).not_to be_valid
      expect(regimen.errors[:cycle_days]).to be_present
    end

    it 'validates total_cycles is greater than 0' do
      regimen = build(:regimen, total_cycles: 0)
      expect(regimen).not_to be_valid
      expect(regimen.errors[:total_cycles]).to be_present
    end
  end

  describe 'scopes' do
    let!(:template1) { create(:regimen_template, name: 'PE療法') }
    let!(:template2) { create(:regimen_template, name: 'S-1単独療法') }
    let!(:cancer_type1) { create(:cancer_type, name: '小細胞肺がん') }
    let!(:cancer_type2) { create(:cancer_type, name: '胃がん') }
    let!(:edition) { create(:reference_edition) }

    let!(:regimen1) do
      create(:regimen,
             regimen_template: template1,
             cancer_type: cancer_type1,
             reference_edition: edition,
             line_of_therapy: '1st')
    end

    let!(:regimen2) do
      create(:regimen,
             regimen_template: template2,
             cancer_type: cancer_type2,
             reference_edition: edition,
             line_of_therapy: '2nd')
    end

    describe '.by_template' do
      it 'filters by template name' do
        result = Regimen.by_template('PE療法')
        expect(result).to include(regimen1)
        expect(result).not_to include(regimen2)
      end
    end

    describe '.by_cancer_type' do
      it 'filters by cancer type name' do
        result = Regimen.by_cancer_type('小細胞肺がん')
        expect(result).to include(regimen1)
        expect(result).not_to include(regimen2)
      end
    end

    describe '.first_line' do
      it 'returns first-line regimens' do
        result = Regimen.first_line
        expect(result).to include(regimen1)
        expect(result).not_to include(regimen2)
      end
    end

    describe '.second_line' do
      it 'returns second-line regimens' do
        result = Regimen.second_line
        expect(result).to include(regimen2)
        expect(result).not_to include(regimen1)
      end
    end
  end

  describe '#full_name' do
    let(:regimen) do
      create(:regimen,
             regimen_template: create(:regimen_template, name: 'PE療法'),
             cancer_type: create(:cancer_type, name: '小細胞肺がん'),
             line_of_therapy: '1st')
    end

    it 'returns full name with template, cancer type, and line' do
      expect(regimen.full_name).to eq('PE療法 / 小細胞肺がん / 1st')
    end

    context 'when line_of_therapy is blank' do
      before { regimen.update(line_of_therapy: nil) }

      it 'returns name without line' do
        expect(regimen.full_name).to eq('PE療法 / 小細胞肺がん')
      end
    end
  end

  describe '#ordered_drugs' do
    let(:regimen) { create(:regimen) }
    let!(:drug1) { create(:drug, generic_name: 'Drug A') }
    let!(:drug2) { create(:drug, generic_name: 'Drug B') }
    let!(:regimen_drug2) { create(:regimen_drug, regimen: regimen, drug: drug2, sequence_number: 2) }
    let!(:regimen_drug1) { create(:regimen_drug, regimen: regimen, drug: drug1, sequence_number: 1) }

    it 'returns drugs ordered by sequence number' do
      ordered = regimen.ordered_drugs
      expect(ordered.first.drug.generic_name).to eq('Drug A')
      expect(ordered.last.drug.generic_name).to eq('Drug B')
    end
  end

  describe 'unique_regimen_combination validation' do
    let(:template) { create(:regimen_template) }
    let(:cancer_type) { create(:cancer_type) }
    let(:edition) { create(:reference_edition) }

    let!(:existing_regimen) do
      create(:regimen,
             regimen_template: template,
             cancer_type: cancer_type,
             reference_edition: edition,
             line_of_therapy: '1st')
    end

    it 'prevents duplicate regimen combinations' do
      duplicate = build(:regimen,
                        regimen_template: template,
                        cancer_type: cancer_type,
                        reference_edition: edition,
                        line_of_therapy: '1st')

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:base]).to include('この組み合わせのレジメンは既に存在します')
    end

    it 'allows different line_of_therapy' do
      different_line = build(:regimen,
                             regimen_template: template,
                             cancer_type: cancer_type,
                             reference_edition: edition,
                             line_of_therapy: '2nd')

      expect(different_line).to be_valid
    end
  end
end
