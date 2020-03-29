require 'rails_helper'

RSpec.describe RoomsController, type: :request do
  # TODO: Remove when beta invite requirements are removed
  before(:each) do
    InviteCode.create(code: 'correct-code')
    post '/validate_beta_user', params: { beta_code: 'correct-code' }
  end

  context "user is authenticated" do
    before(:each) { sign_in create(:user) }

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
  end
end
