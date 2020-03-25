# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  describe 'GET #show' do
    let(:room) { create(:room) }

    it 'renders a room page' do
      get :show, params: { id: room.room_hash }
      expect(response).to be_successful
    end

    it "doesn't allow routing to a room via id" do
      expect do
        get :show, params: { id: room.id }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
