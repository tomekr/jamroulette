# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaticController, type: :request do
  # TODO: Remove when beta invite requirements are removed
  before(:each) do
    InviteCode.create(code: 'correct-code')
    post '/validate_beta_user', params: { beta_code: 'correct-code' }
  end

  describe 'GET #index' do
    it 'returns http success' do
      get home_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #explore' do
    it 'contains link to room' do
      jam = create(:jam, could_use_list: %w[Bass Vocals])
      get explore_path
      expect(response.body).to include(room_path(jam.room))
    end
  end
end
