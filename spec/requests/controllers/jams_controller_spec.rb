require 'rails_helper'

RSpec.describe JamsController, type: :request do
  # TODO: Remove when beta invite requirements are removed
  before do
    InviteCode.create(code: 'correct-code')
    post '/validate_beta_user', params: { beta_code: 'correct-code' }
  end

  let!(:room) { create(:room) }

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

    it 'associates generated activity with the current user' do
      action
      expect(uploaded_jam.activities.first.user).to eq user
    end

    it 'creates a notification' do
      create(:jam, room: room, user: create(:user))

      expect do
        action
      end.to change(Notification, :count).from(0).to(1)
    end

    it 'does not create a notification for the current user' do
      expect do
        action
      end.to_not change{ user.notifications.count }
    end

    context 'tagging' do
      let(:jam_params) do
        {
          bpm: '100',
          song_key: 'A Major',
          jam_type: 'MIX',
          style_list: 'Electronic, Lofi',
          could_use_list: 'Bass, Guitar, Vocals',
          file: file }
      end
      let(:uploaded_jam) { room.reload.jams.first }

      let(:action) { post room_jams_path(room), params: { jam: jam_params } }

      it 'uploads a file with given tags' do
        action

        expect(uploaded_jam.bpm).to eq '100'
        expect(uploaded_jam.song_key).to include('A Major')
        expect(uploaded_jam.jam_type).to include('MIX')
        expect(uploaded_jam.style_list).to include('Electronic', 'Lofi')
        expect(uploaded_jam.could_use_list).to include('Bass', 'Guitar', 'Vocals')
      end
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
