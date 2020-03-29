require 'rails_helper'

RSpec.describe RoomsController, type: :request do
  # TODO: Remove when beta invite requirements are removed
  before(:each) do
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

  context "user is authenticated" do
    let(:user) { create(:user) }
    before(:each) { sign_in user }

    describe 'POST #create' do
      it 'creates an activity' do
        expect do
          post rooms_path
        end.to change(Activity, :count).from(0).to(1)
      end

      it 'associates the activity with the current user' do
        post rooms_path
        room = Room.take
        expect(room.activities.take.user).to eq user
      end
    end
  end
end
