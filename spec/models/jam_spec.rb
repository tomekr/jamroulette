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

  it 'extracts the filename from the file' do
    file = fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'test.mp3'), 'audio/mpeg')
    jam = create(:jam, file: file)

    expect(jam.filename).to eq "test.mp3"
  end
end
