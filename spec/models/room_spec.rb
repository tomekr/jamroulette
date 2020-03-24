# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room, type: :model do
  describe 'Validations' do
    let(:room) { build(:room) }

    it 'is valid out of the factory' do
      expect(room).to be_valid
    end
  end

  it 'generates a random hex room hash' do
    room = create(:room)
    expect(room.room_hash).to match(/[0-9a-f]{32}/)
  end
end
