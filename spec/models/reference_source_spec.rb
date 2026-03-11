# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReferenceSource, type: :model do
  describe 'associations' do
    it { should have_many(:reference_editions).dependent(:restrict_with_error) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:source_type) }
    it { should validate_length_of(:name).is_at_most(200) }
    it { should validate_length_of(:source_type).is_at_most(20) }
    it { should validate_length_of(:publisher).is_at_most(100) }
    it { should validate_length_of(:isbn).is_at_most(20) }
    it { should validate_length_of(:url).is_at_most(255) }
  end

  describe 'factory' do
    it 'creates valid reference source' do
      source = create(:reference_source)
      expect(source).to be_valid
    end

    it 'creates handbook reference source' do
      source = create(:reference_source, :handbook)
      expect(source.name).to eq('がん化学療法レジメンハンドブック')
      expect(source.source_type).to eq('book')
      expect(source.publisher).to eq('羊土社')
    end
  end
end
