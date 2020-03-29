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

    context "user is authenticated" do
      before(:each) { sign_in user }
      let(:user) { create(:user, display_name: "Alice") }

      it "associates user with a created jam" do
        upload_jam(room)
        follow_redirect!

        expect(response.body).to include("Alice")
      end

      it "restricts mime type on form field to audio/*" do
        get room_path(room)
        expect(response.body).to include('accept="audio/*" type="file"')
      end

      context "with server side validation failure" do
        let(:invalid_file) { fixture_file_upload('spec/support/assets/invalid_file.txt') }

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
    end

    context "user is unauthenticated" do
      before(:each) { upload_jam(room) }

      it "redirects user to sign in page" do
        expect(response).to redirect_to(new_user_session_path)
      end

      it "tells user to create an account to upload a jam" do
        upload_jam(room)
        follow_redirect!

        expect(response.body).to include("Please sign in or sign up before creating Rooms or uploading Jams.")
      end
    end
  end
end
