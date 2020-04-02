# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notifications', type: :request do
  # TODO: Remove when beta invite requirements are removed
  before(:each) do
    InviteCode.create(code: 'correct-code')
    post '/validate_beta_user', params: { beta_code: 'correct-code' }
  end

  let(:file) { fixture_file_upload('spec/support/assets/test.mp3') }
  let(:jam_params) { { bpm: '100', file: file } }
  let(:upload_jam) { post room_jams_path(room), params: { jam: jam_params } }

  let(:user) { create(:user) }
  let(:room) { create(:room, user: user, name: 'notification-room') }
  let(:uploader) { create(:user, display_name: 'uploader') }

  context 'room owner' do
    before do
      sign_in uploader
    end

    it 'creates an unread notification' do
      expect do
        upload_jam
      end.to change{ user.notifications.unread.count }
    end

    it 'shows unread notifications in the navbar' do
      upload_jam
      sign_in user
      get home_path
      expect(response.body).to include('uploader uploaded a jam to notification-room')
    end
  end

  context 'room contributor' do
    it 'creates an unread notification' do

    end
  end
end
