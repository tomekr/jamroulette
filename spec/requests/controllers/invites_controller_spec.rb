# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvitesController, type: :request do
  let(:user) { create(:user) }

  # TODO: Remove when beta invite requirements are removed
  before do
    InviteCode.create(code: 'correct-code')
    post '/validate_beta_user', params: { beta_code: 'correct-code' }
  end

  describe 'POST #create' do
    before do
      sign_in(user)
      group.add_owner(user)
    end

    let(:group) { create(:group) }
    let(:recipient) { create(:user) }

    let(:invite_params) { { email: recipient.email, role: 'Member' } }
    let(:action) { post group_invites_path(group), params: { invite: invite_params } }

    it_behaves_like 'Auth Required'
    it_behaves_like 'Owner Required'

    it 'creates an invite' do
      expect do
        action
      end.to change(Invite, :count).by(1)
    end

    it 'redirects to group members index' do
      action
      expect(response).to redirect_to(group_group_memberships_path(group))
    end

    context 'user already in group' do
      before { group.add(recipient) }

      it 'does not create an invite' do
        expect do
          action
        end.to_not change(Invite, :count)
      end

      it 'sets flash alert' do
        action
        expect(flash.alert).to include('Recipient is already in the group')
      end
    end

    context 'user does not exist' do
      let(:invite_params) { { email: 'doesnotexist@example.com' } }

      it 'does not create an invite' do
        expect do
          action
        end.to_not change(Invite, :count)
      end

      it 'sets flash alert' do
        action
        expect(flash.alert).to include('Recipient must exist')
      end
    end

    context 'invite already sent' do
      before { create(:invite, recipient: recipient, group: group) }

      it 'does not create an invite' do
        expect do
          action
        end.to_not change(Invite, :count)
      end

      it 'sets flash alert' do
        action
        expect(flash.alert).to include('Recipient already has a pending invite for this group')
      end
    end
  end
end
