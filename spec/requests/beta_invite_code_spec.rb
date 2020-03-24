# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Closed beta invite codes', type: :request do
  before(:each) do
    InviteCode.create(code: 'correct-code')
  end

  it 'requires a user to have entered a valid invite code before viewing a room' do
    room = create(:room)
    get "/rooms/#{room.room_hash}"

    expect(response).to redirect_to(root_path)
    follow_redirect!

    expect(response.body).to include('Jam Roulette is currently in closed beta.')
  end
end
