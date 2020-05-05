# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Groups', type: :request do
  # TODO: Remove when beta invite requirements are removed
  before(:each) do
    InviteCode.create(code: 'correct-code')
    post '/validate_beta_user', params: { beta_code: 'correct-code' }
  end

  let(:group) { create(:group) }
  let(:user) { create(:user) }
  before(:each) { sign_in user }

  context 'as owner' do
    it 'does not display admin actions for a group' do
      group.add_owner(user)
      get groups_path
      expect(response.body).to include('Edit')
      expect(response.body).to include('Destroy')
    end

    it 'displays invite member form' do
      group.add_owner(user)
      get group_group_memberships_path(group)
      expect(response.body).to include('Invite a member')
    end
  end

  context 'as member' do
    it 'does not display admin actions for a group' do
      group.add(user)
      get groups_path
      expect(response.body).to_not include('Edit')
      expect(response.body).to_not include('Destroy')
    end

    it 'does not display an invite member form' do
      group.add(user)
      get group_group_memberships_path(group)
      expect(response.body).to_not include('Invite a member')
    end
  end

  context 'as non-member' do
    it 'does not display an invite member form' do
      get group_group_memberships_path(group)
      expect(response.body).to_not include('Invite a member')
    end
  end
end
