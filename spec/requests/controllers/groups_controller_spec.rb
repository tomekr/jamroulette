# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupsController, type: :request do
  # TODO: Remove when beta invite requirements are removed
  before do
    InviteCode.create(code: 'correct-code')
    post '/validate_beta_user', params: { beta_code: 'correct-code' }
  end

  describe 'GET #index' do
    it 'displays public groups' do
      create(:group, name: 'The Groovies')
      create(:group, name: 'The Funk Brothers')

      get groups_path

      expect(response.body).to include('The Groovies')
      expect(response.body).to include('The Funk Brothers')
    end
  end

  describe 'POST #create' do
    it_behaves_like 'Auth Required'
    let(:user) { create(:user) }
    before { sign_in(user) }

    let(:group_params) { { name: 'A Public Group', visible: true } }
    let(:action) { post groups_path, params: { group: group_params } }
    let(:created_group) { Group.last }

    it 'creates a group' do
      expect do
        action
      end.to change(Group, :count).by(1)
    end

    it 'creates a group with a given name' do
      action
      expect(created_group.name).to eq 'A Public Group'
    end

    it 'associates new group with user' do
      action
      expect(created_group.members).to include user
    end

    it 'makes current user the owner' do
      action
      expect(user.groups.as(:owner)).to include(created_group)
    end

    context 'public groups' do
      it 'creates a public group' do
        action
        expect(created_group.visible).to be true
      end
    end

    context 'private groups' do
      let(:group_params) { { name: 'A Private Group', visible: false } }

      it 'creates a private group' do
        action
        expect(created_group.visible).to be false
      end
    end
  end

  context 'updating a group' do
    let(:user) { create(:user) }
    before { sign_in(user) }

    let(:group) { create(:group, name: 'My Editable Group') }
    let!(:group_membership) { create(:group_membership, :owner, member: user, group: group) }

    describe 'GET #edit' do
      it_behaves_like 'Auth Required'

      let(:action) { get edit_group_path(group) }
      it 'displays group to edit' do
        action
        expect(response.body).to include('Edit My Editable Group')
      end
    end

    describe 'PUT #update' do
      it_behaves_like 'Auth Required'

      let(:group_update_params) { { name: 'My Updated Group' } }
      let(:action) { put group_path(group), params: { group: group_update_params } }
      let(:updated_group) { Group.last }

      it 'updates the group' do
        action
        expect(updated_group.name).to eq('My Updated Group')
      end
    end
  end
end
