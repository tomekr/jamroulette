# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:room) { create(:room) }

  describe 'Validations' do
    let(:room) { build(:room) }

    it 'is valid out of the factory' do
      expect(room).to be_valid
    end

    it 'requires a room name' do
      room.name = ''
      expect(room).to_not be_valid
    end
  end

  it 'generates a random hex room hash' do
    expect(room.public_id).to match(/[0-9a-f]{32}/)
  end

  it 'creates an activity' do
    expect do
      create(:room)
    end.to change(Activity, :count).by(1)
  end

  describe '.primary_with_could_use' do
    let(:other_room) { create(:room) }

    it 'returns rooms that have a primary jam with a could_use tag' do
      create(:jam, room: other_room, could_use_list: nil)
      create(:jam, room: room, could_use_list: nil)
      create(:jam, room: room, could_use_list: %w[Bass Vocals])
      expect(Room.primary_with_could_use).to contain_exactly(room)
    end
  end

  describe '.recommended' do
    it 'returns a Room that contains a jam' do
      create(:jam, room: room)
      expect(Room.recommended.take).to be_an_instance_of(Room)
    end
  end

  describe '#destroy' do
    context 'given a jam that belongs to a room' do
      it 'destroys the associated jam' do
        jam = create(:jam)
        expect { jam.room.destroy! }.to change(Jam, :count).by(-1)
      end
    end
  end

  describe '#to_param' do
    it 'returns the room hash' do
      expect(room.to_param).to eq room.public_id
    end
  end

  describe '#primary_jam' do
    it 'returns the most recently promoted jam' do
      create(:jam, room: room, promoted_at: 2.minutes.ago)
      create(:jam, room: room, promoted_at: 1.minute.ago)
      primary_jam = create(:jam, room: room, promoted_at: Time.current)

      expect(room.primary_jam).to eq primary_jam
    end
  end

  describe '#users' do
    let(:uploader) { create(:user) }

    it 'returns all participants in the room' do
      create(:jam, room: room, user: room.user)
      create(:jam, room: room, user: uploader)

      expect(room.users).to contain_exactly(room.user, uploader)
    end
  end
end
