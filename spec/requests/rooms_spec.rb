# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Room viewing', type: :request do
  it 'displays current Jam information if it exists' do
    # Lock datetime to Jan 24, 2020 1:4:44
    travel_to Time.zone.local(2020, 1, 24, 0o1, 0o4, 44)

    jam = create(:jam)
    room = jam.room
    get "/rooms/#{room.room_hash}"

    expect(response.body).to include('Latest JAM January, 24 2020')
    expect(response.body).to include("FILE: #{jam.filename}")
    expect(response.body).to include("BPM: #{jam.bpm}")
    expect(response.body).to include('Download Track')

    # Unlock datetime
    travel_back
  end

  it 'displays previous Jam information if it exists' do
    previous_jam = create(:jam, bpm: '100', filename: 'previous-jam.wav')
    current_jam = create(:jam, room: previous_jam.room)

    room = current_jam.room
    get "/rooms/#{room.room_hash}"

    expect(response.body).to include('Previous JAMs on this track')
    expect(response.body).to include("FILE: #{previous_jam.filename}")
    expect(response.body).to include("BPM: #{previous_jam.bpm}")
  end

  it 'does not display Jam attributes one does not exist' do
    room = create(:room)
    get "/rooms/#{room.room_hash}"

    expect(response.body).to_not include('Latest JAM')
    expect(response.body).to_not include('FILE')
    expect(response.body).to_not include('BPM')
    expect(response.body).to_not include('Previous JAMs on this track')
    expect(response.body).to_not include('Download Track')

    expect(response.body).to include('This room is brand new! Upload a track to get started!')
  end
end
