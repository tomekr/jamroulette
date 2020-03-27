# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home page viewing', type: :request do
  # TODO: Remove when beta invite requirements are removed
  it 'redirects to room after code validation if user first visited room' do
    InviteCode.create(code: 'correct-code')
    room = create(:room)

    get room_path(room)
    follow_redirect!

    post '/validate_beta_user', params: { beta_code: 'correct-code' }
    expect(response).to redirect_to(room_path(room))
  end
end
