# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Jams', type: :request do
  # TODO: Remove when beta invite requirements are removed
  before(:each) do
    InviteCode.create(code: 'correct-code')
    post '/validate_beta_user', params: { beta_code: 'correct-code' }
  end

  let(:room) { create(:room) }
  let(:file) { fixture_file_upload('spec/support/assets/test.mp3') }
  let(:jam_params) { { bpm: '100', file: file } }
  let(:upload_jam) { post room_jams_path(room), params: { jam: jam_params } }

  describe 'Uploading a jam' do
    context "user is authenticated" do
      before(:each) { sign_in user }
      let(:user) { create(:user, display_name: "Alice") }

      context 'user email notification' do
        let(:room_owner) { create(:user, email: 'room-owner@example.com') }
        let(:room) { create(:room, name: 'email-room', user: room_owner) }

        before { ActionMailer::Base.deliveries.clear }

        it 'sends an email' do
          expect do
            perform_enqueued_jobs { upload_jam }
          end.to change { ActionMailer::Base.deliveries.count }.by(1)
        end

        it 'notifies room owner' do
          perform_enqueued_jobs { upload_jam }

          email = ActionMailer::Base.deliveries.first
          expect(email.subject).to eq("Alice uploaded a jam to email-room")
          expect(email.to).to eq(["room-owner@example.com"])
        end

        it 'notifies room contributors' do
          contributor = create(:user, email: 'contributor@example.com')
          create(:jam, room: room, user: contributor)

          perform_enqueued_jobs { upload_jam }

          email = ActionMailer::Base.deliveries.last
          expect(email.subject).to eq("Alice uploaded a jam to a room you've contributed to!")
          expect(email.to).to eq(["contributor@example.com"])
        end

        it 'does not send email to the uploader' do
          pending "TODO"
        end
      end

      it "associates user with a created jam" do
        upload_jam
        follow_redirect!

        expect(response.body).to include("Alice")
      end

      it "restricts mime type on form field to audio/*" do
        get room_path(room)
        expect(response.body).to include('accept="audio/*" type="file"')
      end

      context "with an invalid file" do
        let(:file) { fixture_file_upload('spec/support/assets/invalid_file.txt') }

        it "alerts about error" do
          upload_jam
          follow_redirect!

          expect(response.body).to include('must be an audio file')
        end

        it "doesn't create a Jam record" do
          expect do
            upload_jam
          end.to_not change(Jam, :count)
        end
      end
    end

    context "user is unauthenticated" do
      it "redirects user to sign in page" do
        upload_jam
        expect(response).to redirect_to(new_user_session_path)
      end

      it "tells user to create an account to upload a jam" do
        upload_jam
        follow_redirect!

        expect(response.body).to include("Please sign in or sign up before creating Rooms or uploading Jams.")
      end
    end
  end
end
