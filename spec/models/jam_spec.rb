require 'rails_helper'

RSpec.describe Jam, type: :model do
  describe 'Validations' do
    let(:jam) { build(:jam) }

    it 'is valid out of the factory' do
      expect(jam).to be_valid
    end

    it 'is not valid without a file' do
      jam.file = nil
      expect(jam).to_not be_valid
    end
  end
end
