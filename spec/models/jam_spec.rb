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
      expect(jam.errors[:file]).to include("must be attached")
    end

    it 'only allows content types of audio/*' do
      jam.file = fixture_file_upload('spec/support/assets/invalid_file.txt')
      expect(jam).to_not be_valid
      expect(jam.errors[:file]).to include("must be an audio file")
    end
  end
end
