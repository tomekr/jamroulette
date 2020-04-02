# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notifications', type: :request do
  # TODO: Remove when beta invite requirements are removed
  before(:each) do
    InviteCode.create(code: 'correct-code')
    post '/validate_beta_user', params: { beta_code: 'correct-code' }
  end

  let(:user) { create(:user) }
  let(:uploader) { create(:user, display_name: 'uploader') }
  let(:room) { create(:room, name: 'notification-room') }
  let(:jam) { create(:jam, room: room) }

  before { sign_in user }

  it 'shows unread notifications in the navbar' do
    create(:notification, :jam, target: jam, user: user, actor: uploader)
    get home_path
    expect(response.body).to include('uploader uploaded a jam to notification-room')
  end
end