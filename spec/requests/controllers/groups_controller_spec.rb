# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupsController, type: :request do
  # TODO: Remove when beta invite requirements are removed
  before do
    InviteCode.create(code: 'correct-code')
    post '/validate_beta_user', params: { beta_code: 'correct-code' }
  end

  let(:user) { create(:user) }

  describe 'GET #index' do
    it 'displays public groups' do
      create(:group, name: 'The Groovies')
      create(:group, name: 'The Funk Brothers')

      get groups_path

      expect(response.body).to include('The Groovies')
      expect(response.body).to include('The Funk Brothers')
    end

    context 'is a member of a private group' do
      let(:group) { create(:group, :private, name: 'Private Group') }
      before { sign_in(user) }

      it 'displays private groups owned by user' do
        create(:group_membership, :owner, member: user, group: group)

        get groups_path
        expect(response.body).to include('Private Group')
      end

      it 'displays private groups' do
        create(:group_membership, member: user, group: group)

        get groups_path
        expect(response.body).to include('Private Group')
      end
    end

    it 'does not display private groups if user is not a member' do
      create(:group, :private, name: 'Private Group')
      sign_in create(:user)

      get groups_path
      expect(response.body).to_not include('Private Group')
    end
  end

  describe 'GET #show' do
    before { sign_in(user) }

    it 'allows members to view a private group' do
      group = create(:group, :private, name: 'Private Group')
      create(:group_membership, member: user, group: group)

      get group_path(group)
      expect(response.body).to include('Private Group')
    end

    it 'does not allow non members to view a private group' do
      group = create(:group, :private)
      sign_in create(:user)

      get group_path(group)
      expect(response).to_not be_successful
    end

    it 'allows non members to view a public group' do
      group = create(:group, :public)
      sign_in create(:user)

      get group_path(group)

      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it_behaves_like 'Auth Required'
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

    context 'invalid group' do
      it 'displays error message if name is not given' do
        group_params[:name] = ''
        action
        expect(response.body).to include(CGI.escapeHTML('Name can\'t be blank'))
      end
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
    before { sign_in(user) }

    let(:group) { create(:group, name: 'My Editable Group') }
    let!(:group_membership) { create(:group_membership, :owner, member: user, group: group) }

    describe 'GET #edit' do
      it_behaves_like 'Auth Required'
      it_behaves_like 'Owner Required'

      let(:action) { get edit_group_path(group) }

      it 'displays group to edit' do
        action
        expect(response.body).to include('Edit My Editable Group')
      end
    end

    describe 'PUT #update' do
      it_behaves_like 'Auth Required'
      it_behaves_like 'Owner Required'

      let(:group_update_params) { { name: 'My Updated Group' } }
      let(:action) { put group_path(group), params: { group: group_update_params } }
      let(:target) { Group.last }

      it 'updates the group' do
        action
        expect(target.name).to eq('My Updated Group')
      end

      context 'invalid group' do
        it 'displays error message if name is not given' do
          group_update_params[:name] = ''

          action
          expect(response.body).to include(CGI.escapeHTML('Name can\'t be blank'))
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    it_behaves_like 'Auth Required'
    it_behaves_like 'Owner Required'
    before { sign_in(user) }

    let!(:group_membership) { create(:group_membership, :owner, member: user) }
    let(:action) { delete group_path(group_membership.group) }

    it 'destroys a group' do
      expect do
        action
      end.to change(Group, :count).by(-1)
    end
  end
end