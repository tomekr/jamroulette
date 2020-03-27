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
end
