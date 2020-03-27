# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaticController, type: :controller do
  describe 'GET #index' do
    # TODO: Remove when beta invite requirements are removed
    before(:each) do
      session[:is_beta_user] = true
    end

    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  # TODO: Remove when beta invite requirements are removed
  describe 'POST #validate_beta_user' do
    context 'with valid invite code' do
      it 'redirects to referer if it exists' do
        InviteCode.create(code: 'valid-code')
        room = create(:room)

        request.env['HTTP_REFERER'] = room_path(room)
        post :validate_beta_user, params: { beta_code: 'valid-code' }

        expect(response).to redirect_to room_path(room)
      end
    end
  end
end
