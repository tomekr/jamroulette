# frozen_string_literal: true

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
      expect(jam.errors[:file]).to include('must be attached')
    end

    it 'only allows content types of audio/*' do
      jam.file = fixture_file_upload('spec/support/assets/invalid_file.txt')
      expect(jam).to_not be_valid
      expect(jam.errors[:file]).to include('must be an audio file')
    end

    it 'does not allow jam type that is not Mix, Solo, or Idea' do
      jam.jam_type_list = ['Invalid']
      expect(jam).to_not be_valid
    end

    it 'allows absence of promotion' do
      jam.promoted_at = nil
      expect(jam).to be_valid
    end

    it 'allows mixes to be promoted' do
      jam = build(:jam, :mix, promoted_at: Time.current)
      expect(jam).to be_valid
    end

    it 'allows ideas to be promoted' do
      jam = build(:jam, :idea, promoted_at: Time.current)
      expect(jam).to be_valid
    end

    it 'does not allow solos to be promoted' do
      jam = build(:jam, :solo, promoted_at: Time.current)
      expect(jam).to_not be_valid
    end
  end

  context 'automatic promotion on create' do
    it 'promotes mixes' do
      freeze_time do
        jam = create(:jam, :mix)
        expect(jam.promoted_at).to eq(Time.current)
      end
    end

    it 'does not promote ideas' do
      jam = create(:jam, :idea)
      expect(jam.promoted_at).to be nil
    end

    it 'does not promote solos' do
      jam = create(:jam, :solo)
      expect(jam.promoted_at).to be nil
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
      jam.file.content_type = 'audio/midi'
      expect(jam.midi?).to be true
    end

    example 'audio/x-midi' do
      jam.file.content_type = 'audio/x-midi'
      expect(jam.midi?).to be true
    end

    example 'audio/ogg' do
      jam.file.content_type = 'audio/ogg'
      expect(jam.midi?).to be false
    end
  end

  describe '#idea?' do
    example 'jam is an idea' do
      jam = build(:jam, :idea)
      expect(jam.idea?).to be true
    end

    example 'jam is a solo' do
      jam = build(:jam, :solo)
      expect(jam.idea?).to be false
    end

    example 'jam is a mix' do
      jam = build(:jam)
      expect(jam.idea?).to be false
    end
  end

  describe '#promote' do
    it 'sets promoted_at field' do
      freeze_time do
        jam.promote
        expect(jam.promoted_at).to eq(Time.current)
      end
    end
  end

  describe '#mix?' do
    example 'jam is an idea' do
      jam = build(:jam, :idea)
      expect(jam.mix?).to be false
    end

    example 'jam is a solo' do
      jam = build(:jam, :solo)
      expect(jam.mix?).to be false
    end

    example 'jam is a mix' do
      jam = build(:jam, :mix)
      expect(jam.mix?).to be true
    end
  end
end
