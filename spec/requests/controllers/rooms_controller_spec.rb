# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomsController, type: :request do
  # TODO: Remove when beta invite requirements are removed
  before do
    InviteCode.create(code: 'correct-code')
    post '/validate_beta_user', params: { beta_code: 'correct-code' }
  end

  describe 'GET #show' do
    let(:room) { create(:room) }

    it 'renders a room page' do
      get room_path(room.public_id)
      expect(response).to be_successful
    end

    it "doesn't allow routing to a room via id" do
      expect do
        get "/rooms/#{room.id}"
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'returns a jam if there are more than 20 supporting jams' do
      create(:jam, :mix, room: room)
      create_list(:jam, 20, :solo, room: room)

      get room_path(room)
      expect(response.body).to include('<span class="jam-value">Mix</span>')
    end
  end

  describe 'POST #create' do
    it_behaves_like 'Auth Required'
    let(:room) { build(:room) }
    let(:action) do
      post rooms_path, params: {
        room: { name: room.name }
      }
    end

    let(:user) { create(:user) }
    before { sign_in(user) }

    it 'creates a room' do
      expect { action }.to change(Room, :count).by(1)
    end

    it 'associates the room with the current user' do
      action
      room = Room.last
      expect(room.user).to eq user
    end

    it 'creates an activity' do
      expect { action }.to change(Activity, :count).by(1)
    end

    it 'associates the activity with the current user' do
      action
      room = Room.last
      expect(room.activities.take.user).to eq user
    end

    context 'invalid room' do
      let(:room) { build(:room, name: '') }

      it 'redirects to previous page with error' do
        post rooms_path, params: { room: { name: room.name } },
                         headers: { 'Referer': '/previous_page' }
        expect(response).to redirect_to('/previous_page')
      end

      it 'adds error to flash' do
        action
        expect(flash.alert).to include("Name can't be blank")
      end
    end
  end

  describe 'GET #random' do
    let(:action) { get random_rooms_path }

    it 'redirects to a room with a jam' do
      jam = create(:jam)
      action
      expect(response).to redirect_to(room_path(jam.room))
    end

    context 'empty room' do
      let!(:room) { create(:room) }

      it 'redirects to home page' do
        action
        expect(response).to redirect_to(home_path)
      end

      it 'shows a flash message' do
        action
        expect(flash.alert).to include('No rooms with a jam exist')
      end
    end
  end
end
