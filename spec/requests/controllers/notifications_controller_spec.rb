require 'rails_helper'

RSpec.describe NotificationsController, type: :request do
  # TODO: Remove when beta invite requirements are removed
  before do
    InviteCode.create(code: 'correct-code')
    post '/validate_beta_user', params: { beta_code: 'correct-code' }
  end

  describe 'GET #index' do
    it_behaves_like 'Auth Required'
    let(:user) { create(:user) }
    before { sign_in(user) }

    let(:action) { get user_notifications_path(user) }

    context 'json request' do
      let(:action) do
        headers = { 'Accept': 'application/json' }
        get user_notifications_path(user), headers: headers
      end

      it 'returns non-empty array as json' do
        create(:notification, user: user)

        action

        expect(response).to be_successful
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(JSON.parse(response.body)).to_not be_empty
      end
    end
  end

  describe 'PUT #read' do
    it_behaves_like 'Auth Required'

    let(:user) { create(:user) }
    before { sign_in(user) }

    let(:action) { put read_user_notifications_path(user) }

    context 'json' do
      let(:action) do
        headers = { 'Accept': 'application/json' }
        put read_user_notifications_path(user), headers: headers
      end

      it 'is successful' do
        action
        expect(response).to be_successful
      end

      it 'marks an unread notification read' do
        create(:notification, user: user)

        expect do
          action
        end.to change { user.notifications.unread.count }.from(1).to(0)
      end
    end
  end
end
