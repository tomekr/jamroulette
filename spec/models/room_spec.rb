# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:room) { build(:room) }

  describe 'Validations' do
    it 'is valid out of the factory' do
      expect(room).to be_valid
    end
  end

  it 'generates a random hex room hash' do
    room.save
    expect(room.room_hash).to match(/[0-9a-f]{32}/)
  end

  describe '#to_param' do
    context 'given a room that exists in the database' do
      it 'returns the room hash' do
        room.save

        expect(room.to_param).to eq room.room_hash
      end
    end

    context 'given a room that does NOT exist in the database' do
      it 'returns nil' do
        room = build(:room)

        expect(room.to_param).to be_nil
      end
    end
  end
end
