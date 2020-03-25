# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:room) { create(:room) }

  describe 'Validations' do
    let(:room) { build(:room) }

    it 'is valid out of the factory' do
      expect(room).to be_valid
    end
  end

  it 'generates a random hex room hash' do
    expect(room.room_hash).to match(/[0-9a-f]{32}/)
  end

  describe '#destroy' do
    context 'given a jam that belongs to a room' do
      it 'destroys the associated jam' do
        create(:jam, room: room)
        expect { room.destroy }.to change(Jam, :count).by(-1)
      end
    end
  end

  describe '#to_param' do
    it 'returns the room hash' do
      expect(room.to_param).to eq room.room_hash
    end
  end
end