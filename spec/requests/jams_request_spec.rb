# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Jams', type: :request do
  context 'Uploading a jam' do
    let(:file) { fixture_file_upload('spec/support/assets/test.mp3') }

    it 'allows user to upload a jam' do
      room = create(:room)
      post room_jams_path(room), params: { jam: { bpm: '100', file: file } }

      jam = room.reload.jams.first

      expect(jam).to_not be_nil
      expect(jam.filename).to eq file.original_filename
      expect(jam.file).to be_kind_of(ActiveStorage::Attached)

      follow_redirect!
      expect(response.body).to include(file.original_filename)
      expect(response.body).to include('BPM: 100')
    end
  end
end
