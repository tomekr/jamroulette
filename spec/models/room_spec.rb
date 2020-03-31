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

  describe ".recommended" do
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

  describe '#users' do
    let(:uploader) { create(:user) }

    it 'returns all participants in the room' do
      create(:jam, room: room, user: room.user)
      create(:jam, room: room, user: uploader)

      expect(room.users).to match([room.user, uploader])
    end
  end

  describe '#self.random_id' do
    it 'returns a random room id' do
      jam = create(:jam, room: room)
      room_2 = create(:room)
      jam_2 = create(:jam, room: room_2)
      room_3 = create(:room)
      20.times do
        expect(Room.random_id).to be_in([room.public_id, room_2.public_id])
      end
    end
  end
end
