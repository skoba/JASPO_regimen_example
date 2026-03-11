# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReferenceEdition, type: :model do
  describe 'associations' do
    it { should belong_to(:reference_source) }
    it { should have_many(:regimens).dependent(:restrict_with_error) }
  end

  describe 'validations' do
    it { should validate_presence_of(:edition_number) }
    it { should validate_length_of(:edition_number).is_at_most(20) }
  end

  describe 'factory' do
    it 'creates valid reference edition' do
      edition = create(:reference_edition)
      expect(edition).to be_valid
    end

    it 'creates edition 8' do
      edition = create(:reference_edition, :edition_8)
      expect(edition.edition_number).to eq('第8版')
      expect(edition.publication_date).to eq(Date.new(2023, 3, 1))
    end
  end

  describe '#full_name' do
    let(:source) { create(:reference_source, name: 'Test Source') }
    let(:edition) { create(:reference_edition, reference_source: source, edition_number: '第1版') }

    it 'returns full name with source and edition' do
      expect(edition.full_name).to eq('Test Source 第1版')
    end
  end
end
