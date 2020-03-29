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

  describe 'POST #create' do
    let(:file) { fixture_file_upload('spec/support/assets/test.mp3') }
    let(:jam_params) { { bpm: '100', file: file } }
    let(:upload_jam) { post room_jams_path(room), params: { jam: jam_params } }

    context 'with a valid jam' do
      it 'allows user to upload a jam' do
        upload_jam
        jam = room.reload.jams.first

        expect(jam).to_not be_nil
        expect(jam.file.filename).to eq file.original_filename
        expect(jam.file).to be_kind_of(ActiveStorage::Attached)

        follow_redirect!
        expect(response.body).to include(file.original_filename)
        expect(response.body).to include(jam.bpm)
        expect(response.body).to include('Jam successfully created!')
      end
    end

    context "with an invalid file" do
      let(:file) { fixture_file_upload('spec/support/assets/invalid_file.txt') }

      it "redirects to the home page" do
        upload_jam
        expect(request).to redirect_to(room_path(room))
      end
    end
  end
end
