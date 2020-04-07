# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home page viewing', type: :request do
  # TODO: Remove when beta invite requirements are removed
  def validate_beta_user
    InviteCode.create(code: 'correct-code')
    post '/validate_beta_user', params: { beta_code: 'correct-code' }
  end

  it 'redirects to room after code validation if user first visited room' do
    room = create(:room)

    get room_path(room)
    follow_redirect!

    validate_beta_user
    expect(response).to redirect_to(room_path(room))
  end

  context 'user is unauthenticated' do
    before(:each) { validate_beta_user }

    context 'creating a room' do
      it 'redirects to sign in page' do
        post rooms_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
