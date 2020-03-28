# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Jams', type: :request do
  # TODO: Remove when beta invite requirements are removed
  before(:each) do
    InviteCode.create(code: 'correct-code')
    post '/validate_beta_user', params: { beta_code: 'correct-code' }
  end

  def upload_jam(room)
    post room_jams_path(room), params: { jam: { bpm: '100', file: file } }
    room.reload.jams.first
  end

  describe 'Uploading a jam' do
    let(:file) { fixture_file_upload('spec/support/assets/test.mp3') }
    let(:room) { create(:room) }

    it 'allows user to upload a jam' do
      jam = upload_jam(room)

      expect(jam).to_not be_nil
      expect(jam.file.filename).to eq file.original_filename
      expect(jam.file).to be_kind_of(ActiveStorage::Attached)

      follow_redirect!
      expect(response.body).to include(file.original_filename)
      expect(response.body).to include(jam.bpm)
      expect(response.body).to include('Jam successfully created!')
    end

    it "restricts mime type on form field to audio/*" do
      get room_path(room)
      expect(response.body).to include('accept="audio/*" type="file"')
    end

    context "with server side validation failure" do
      let(:invalid_file) { fixture_file_upload('spec/support/assets/invalid_file.txt') }

      it "redirects to the home page" do
        post room_jams_path(room), params: { jam: { bpm: '100', file: invalid_file } }

        expect(request).to redirect_to(room_path(room))
      end

      it "alerts about error" do
        post room_jams_path(room), params: { jam: { bpm: '100', file: invalid_file } }

        follow_redirect!
        expect(response.body).to include('must be an audio file')
      end

      it "doesn't create a Jam record" do
        expect do
          post room_jams_path(room), params: { jam: { bpm: '100', file: invalid_file } }
        end.to_not change(Jam, :count)
      end
    end

    context "user is unauthenticated" do
      it "does not associate a user with a created jam" do
        upload_jam(room)
        follow_redirect!

        expect(response.body).to include("User - Anonymous")
      end
    end

    context "user is authenticated" do
      it "associates user with a created jam" do
        user = create(:user, display_name: "Alice")
        sign_in user

        upload_jam(room)
        follow_redirect!

        expect(response.body).to include("User - Alice")
      end
    end
  end
end
