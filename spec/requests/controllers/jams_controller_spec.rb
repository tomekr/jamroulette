require 'rails_helper'

RSpec.describe JamsController, type: :request do
  # TODO: Remove when beta invite requirements are removed
  before(:each) do
    InviteCode.create(code: 'correct-code')
    post '/validate_beta_user', params: { beta_code: 'correct-code' }
  end

  let(:user) { create(:user, display_name: "Alice") }
  before(:each) { sign_in user }

  let(:room) { create(:room) }
  let(:valid_file) { fixture_file_upload('spec/support/assets/test.mp3') }

  describe 'POST #create' do
    def upload_jam(room, file=valid_file)
      post room_jams_path(room), params: {
        jam: {
          bpm: '100',
          file: file
        }
      }
      room.reload.jams.first
    end

    it 'allows user to upload a jam' do
      jam = upload_jam(room, valid_file)

      expect(jam).to_not be_nil
      expect(jam.file.filename).to eq valid_file.original_filename
      expect(jam.file).to be_kind_of(ActiveStorage::Attached)

      follow_redirect!
      expect(response.body).to include(valid_file.original_filename)
      expect(response.body).to include(jam.bpm)
      expect(response.body).to include('Jam successfully created!')
    end

    context "with server side validation failure" do
      let(:invalid_file) { fixture_file_upload('spec/support/assets/invalid_file.txt') }

      it "redirects to the home page" do
        upload_jam(room, invalid_file)

        expect(request).to redirect_to(room_path(room))
      end

    end
  end
end
