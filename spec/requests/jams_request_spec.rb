# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Jams', type: :request do
  context 'Uploading a jam' do
    let(:file) { fixture_file_upload('spec/support/assets/test.mp3') }
    let(:room) { create(:room) }

    it 'allows user to upload a jam' do
      post room_jams_path(room), params: { jam: { bpm: '100', file: file } }

      jam = room.reload.jams.first

      expect(jam).to_not be_nil
      expect(jam.file.filename).to eq file.original_filename
      expect(jam.file).to be_kind_of(ActiveStorage::Attached)

      follow_redirect!
      expect(response.body).to include(file.original_filename)
      expect(response.body).to include('BPM: 100')
      expect(response.body).to include('Jam successfully created!')
    end

    it 'fails if a file is not specified' do
      expect do
        post room_jams_path(room), params: { jam: { bpm: '100', file: nil } }
      end.to_not change(Jam, :count)

      expect(request).to redirect_to(room_path(room))
      follow_redirect!
      expect(response.body).to include('A file must be specified.')
    end
  end
end
