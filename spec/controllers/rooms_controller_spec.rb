# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomsController, type: :controller do
  describe 'GET #show' do
    let(:room) { create(:room) }

    it 'renders a room page' do
      get :show, params: { room_hash: room.room_hash }
      expect(response.status).to eq(200)
    end

    it "doesn't allow routing to a room via id" do
      get :show, params: { id: room.id, room_hash: room.id }
      expect(response.status).to eq 404
    end
  end
end
