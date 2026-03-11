# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegimenTemplate, type: :model do
  describe 'associations' do
    it { should have_many(:regimens).dependent(:restrict_with_error) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(100) }
  end

  describe 'factory' do
    it 'creates valid regimen template' do
      template = create(:regimen_template)
      expect(template).to be_valid
    end

    it 'creates PE therapy template' do
      template = create(:regimen_template, :pe_therapy)
      expect(template.name).to eq('PE療法')
      expect(template.description).to eq('Cisplatin + Etoposide')
    end
  end
end
