# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Room viewing', type: :request do
  # TODO: Remove when beta invite requirements are removed
  before(:each) do
    InviteCode.create(code: 'correct-code')
    post '/validate_beta_user', params: { beta_code: 'correct-code' }
  end

  let(:current_jam) { create(:jam, room: room, bpm_list: ['120']) }
  let(:room) { build(:room) }
  let(:room_params) { { room: { name: room.name } } }

  context 'user is unauthenticated' do
    it 'redirects user to sign in page' do
      post rooms_path, params: room_params
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  it 'displays current Jam information if it exists' do
    # Lock datetime to Jan 24, 2020 1:4:44
    travel_to Time.zone.local(2020, 1, 24, 0o1, 0o4, 44) do
      get room_path(current_jam.room)

      expect(response.body).to include('January 24, 2020 01:04')
      expect(response.body).to include(current_jam.file.filename.to_s)
      expect(response.body).to include(current_jam.bpm)
      expect(response.body).to include('Download Track')
    end
  end

  it 'displays supporting jams if they exist' do
    previous_jam = create(:jam, room: current_jam.room, bpm_list: ['120'])
    get room_path(previous_jam.room)

    expect(response.body).to include('Supporting Jams')
    expect(response.body).to include(previous_jam.file.filename.to_s)
    expect(response.body).to include(previous_jam.bpm)

    # Check for the download link
    previous_jam_path = URI.parse(url_for(previous_jam.file)).path
    expect(response.body).to include(previous_jam_path)
  end

  it 'does not display Jam attributes if they do not exist' do
    room = create(:room)
    get room_path(room)

    expect(response.body).to_not include('Latest JAM')
    expect(response.body).to_not include('Supporting Jams')
    expect(response.body).to_not include('Download Track')

    expect(response.body).to include('This room is brand new! Upload a track to get started!')
  end
end
