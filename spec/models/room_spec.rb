# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room, type: :model do
  it 'generates a random hex room hash' do
    room = create(:room)
    expect(room.room_hash).to match(/[0-9a-f]{32}/)
  end
end
