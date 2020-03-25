# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Room viewing', type: :request do
  # TODO: Remove when beta invite requirements are removed
  before(:each) do
    InviteCode.create(code: 'correct-code')
    post '/validate_beta_user', params: { beta_code: 'correct-code' }
  end

  let(:room) { create(:room) }
  let(:current_jam) { create(:jam, room: room) }

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

  it 'displays previous Jam information if it exists' do
    previous_jam = create(:jam, room: current_jam.room)
    get room_path(previous_jam.room)

    expect(response.body).to include('Previous JAMs on this track')
    expect(response.body).to include(previous_jam.file.filename.to_s)
    expect(response.body).to include(previous_jam.bpm)

    # Check for the download link
    previous_jam_path = URI.parse(url_for(previous_jam.file)).path
    expect(response.body).to include(previous_jam_path)
  end

  it 'does not display Jam attributes one does not exist' do
    get room_path(room)

    expect(response.body).to_not include('Latest JAM')
    expect(response.body).to_not include('Previous JAMs on this track')
    expect(response.body).to_not include('Download Track')

    expect(response.body).to include('This room is brand new! Upload a track to get started!')
  end
end
