# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  # TODO: Remove when beta invite requirements are removed
  before(:each) do
    session[:is_beta_user] = true
  end

  describe 'GET #show' do
    let(:room) { create(:room) }

    it 'renders a room page' do
      get :show, params: { id: room.public_id }
      expect(response).to be_successful
    end

    it "doesn't allow routing to a room via id" do
      expect do
        get :show, params: { id: room.id }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
