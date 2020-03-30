require 'rails_helper'

RSpec.describe JamsController, type: :request do
  # TODO: Remove when beta invite requirements are removed
  before do
    InviteCode.create(code: 'correct-code')
    post '/validate_beta_user', params: { beta_code: 'correct-code' }
  end

  let(:room) { create(:room) }

  describe 'POST #create' do
    it_behaves_like 'Auth Required'
    let(:user) { create(:user) }
    before { sign_in(user) }

    let(:file) { fixture_file_upload('spec/support/assets/test.mp3') }
    let(:jam_params) { { bpm: '100', file: file } }
    let(:uploaded_jam) { room.reload.jams.first }

    let(:action) { post room_jams_path(room), params: { jam: jam_params } }

    it 'uploads a jam' do
      action

      expect(uploaded_jam).to_not be_nil
      expect(uploaded_jam.file.filename).to eq file.original_filename
      expect(uploaded_jam.file).to be_kind_of(ActiveStorage::Attached)
    end

    it 'lists the uploaded jam' do
      action
      follow_redirect!

      expect(response.body).to include(file.original_filename)
      expect(response.body).to include(uploaded_jam.bpm)
      expect(response.body).to include('Jam successfully created!')
    end

    it 'creates an activity' do
      expect do
        action
      end.to change(Activity, :count).from(0).to(1)
    end

    it 'associates the activity with the current user' do
      action
      expect(uploaded_jam.activities.first.user).to eq user
    end

    context "with an invalid file" do
      let(:file) { fixture_file_upload('spec/support/assets/invalid_file.txt') }

      it "redirects to the home page" do
        action
        expect(request).to redirect_to(room_path(room))
      end
    end
  end
end
