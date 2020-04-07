require 'rails_helper'

RSpec.describe Jam, type: :model do
  let(:jam) { build(:jam) }

  describe 'Validations' do
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

    it 'does not allow jam type that is not Mix, Solo, or Idea' do
      jam.jam_type_list = ['Invalid']
      expect(jam).to_not be_valid
    end
  end

  it 'creates an activity' do
    jam = build(:jam, room: create(:room))
    expect do
      jam.save
    end.to change(Activity, :count).by(1)
  end

  describe '#midi?' do
    example 'audio/midi' do
      jam.file.content_type = "audio/midi"
      expect(jam.midi?).to be true
    end

    example 'audio/x-midi' do
      jam.file.content_type = "audio/x-midi"
      expect(jam.midi?).to be true
    end

    example 'audio/ogg' do
      jam.file.content_type = "audio/ogg"
      expect(jam.midi?).to be false
    end
  end
end
