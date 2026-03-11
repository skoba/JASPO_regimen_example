# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TimingCode, type: :model do
  describe 'associations' do
    it { should have_many(:schedule_timings) }
  end

  describe 'validations' do
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:display) }
    it { should validate_length_of(:code).is_at_most(20) }
    it { should validate_length_of(:display).is_at_most(50) }
    it { should validate_length_of(:fhir_when_code).is_at_most(20) }
  end

  describe 'factory' do
    it 'creates valid timing code' do
      timing_code = create(:timing_code)
      expect(timing_code).to be_valid
    end

    it 'creates morning timing code' do
      timing_code = create(:timing_code, :morning)
      expect(timing_code.code).to eq('MORN')
      expect(timing_code.display).to eq('朝')
    end
  end
end
