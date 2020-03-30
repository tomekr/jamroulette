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
  end

  describe 'POST #create' do
    it_behaves_like "Auth Required"
    let(:action) { post rooms_path }

    let(:user) { create(:user) }
    before { sign_in(user) }


    it 'creates a room' do
      expect { action }.to change(Room, :count).by(1)
    end

    it 'creates an activity' do
      expect { action }.to change(Activity, :count).by(1)
    end

    it 'associates the activity with the current user' do
      action
      room = Room.last
      expect(room.activities.take.user).to eq user
    end
  end
end
