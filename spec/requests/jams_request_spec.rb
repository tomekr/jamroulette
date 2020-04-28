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
  let(:jam_params) { { bpm_list: '100', file: file } }
  let(:upload_jam) { post room_jams_path(room), params: { jam: jam_params } }

  describe 'Uploading a jam' do
    context 'user is authenticated' do
      before(:each) { sign_in user }
      let(:user) { create(:user, display_name: 'Alice') }

      it 'associates user with a created jam' do
        upload_jam
        follow_redirect!

        expect(response.body).to include('Alice')
      end

      it 'restricts mime type on form field to audio/*' do
        get room_path(room)
        expect(response.body).to include('accept="audio/*"')
      end

      context 'with a MIDI file' do
        let(:file) { fixture_file_upload('spec/support/assets/test.mid') }

        it "doesn't display a playable waveform" do
          upload_jam
          follow_redirect!
          expect(response.body).to include('<span class="jam-value">MIDI File</span>')
        end
      end

      context 'with an invalid file' do
        let(:file) { fixture_file_upload('spec/support/assets/invalid_file.txt') }

        it 'alerts about error' do
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

    context 'user is unauthenticated' do
      it 'redirects user to sign in page' do
        upload_jam
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'tells user to create an account to upload a jam' do
        upload_jam
        follow_redirect!

        expect(response.body).to include('Please sign in or sign up before creating Rooms or uploading Jams.')
      end
    end
  end
end
